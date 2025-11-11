import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus {
  online,
  offline,
  unknown,
}

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectionStatus> _statusController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  ConnectionStatus _currentStatus = ConnectionStatus.unknown;

  ConnectionStatus get currentStatus => _currentStatus;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    // Check initial connectivity
    await _updateConnectionStatus();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(results);
    });
  }

  Future<void> _updateConnectionStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      _currentStatus = ConnectionStatus.unknown;
      _statusController.add(_currentStatus);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _currentStatus = ConnectionStatus.offline;
    } else {
      _currentStatus = ConnectionStatus.online;
    }
    _statusController.add(_currentStatus);
  }

  bool get isOnline => _currentStatus == ConnectionStatus.online;

  bool get isOffline => _currentStatus == ConnectionStatus.offline;

  void dispose() {
    _statusController.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});
