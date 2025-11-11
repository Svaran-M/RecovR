import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_service.dart';
import 'settings_service.dart';

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final int pendingChanges;

  const SyncState({
    required this.status,
    this.lastSyncTime,
    this.errorMessage,
    this.pendingChanges = 0,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncTime,
    String? errorMessage,
    int? pendingChanges,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }
}

class SyncService {
  final ConnectivityService _connectivityService;
  final SettingsService _settingsService;
  final StreamController<SyncState> _stateController =
      StreamController<SyncState>.broadcast();

  Stream<SyncState> get stateStream => _stateController.stream;
  SyncState _currentState = const SyncState(status: SyncStatus.idle);

  SyncState get currentState => _currentState;

  SyncService(this._connectivityService, this._settingsService) {
    _init();
  }

  void _init() {
    // grab last sync time
    final lastSync = _settingsService.getLastSyncTime();
    _updateState(_currentState.copyWith(lastSyncTime: lastSync));

    // auto-sync when connection comes back
    _connectivityService.statusStream.listen((status) {
      if (status == ConnectionStatus.online &&
          _settingsService.getAutoSyncEnabled()) {
        syncData();
      }
    });
  }

  void _updateState(SyncState newState) {
    _currentState = newState;
    _stateController.add(_currentState);
  }

  Future<void> syncData() async {
    if (_currentState.status == SyncStatus.syncing) {
      return; // already syncing
    }

    if (!_connectivityService.isOnline) {
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        errorMessage: 'No internet connection',
      ));
      return;
    }

    _updateState(_currentState.copyWith(status: SyncStatus.syncing));

    try {
      // simulated sync - will connect to Supabase later
      await Future.delayed(const Duration(seconds: 2));

      final now = DateTime.now();
      await _settingsService.setLastSyncTime(now);

      _updateState(_currentState.copyWith(
        status: SyncStatus.success,
        lastSyncTime: now,
        pendingChanges: 0,
        errorMessage: null,
      ));

      // back to idle after a moment
      Future.delayed(const Duration(seconds: 2), () {
        if (_currentState.status == SyncStatus.success) {
          _updateState(_currentState.copyWith(status: SyncStatus.idle));
        }
      });
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
      ));

      // show error briefly then reset
      Future.delayed(const Duration(seconds: 3), () {
        if (_currentState.status == SyncStatus.error) {
          _updateState(_currentState.copyWith(status: SyncStatus.idle));
        }
      });
    }
  }

  void markDataChanged() {
    _updateState(_currentState.copyWith(
      pendingChanges: _currentState.pendingChanges + 1,
    ));
  }

  void dispose() {
    _stateController.close();
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  final service = SyncService(connectivityService, SettingsService.instance);
  ref.onDispose(() => service.dispose());
  return service;
});

final syncStateProvider = StreamProvider<SyncState>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.stateStream;
});
