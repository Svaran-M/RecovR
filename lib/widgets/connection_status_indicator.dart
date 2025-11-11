import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';

class ConnectionStatusIndicator extends ConsumerWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);

    return connectionStatus.when(
      data: (status) {
        if (status == ConnectionStatus.online) {
          return const SizedBox.shrink(); // Hide when online
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: status == ConnectionStatus.offline
              ? Colors.orange.shade700
              : Colors.grey.shade600,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status == ConnectionStatus.offline
                    ? Icons.cloud_off
                    : Icons.help_outline,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                status == ConnectionStatus.offline
                    ? 'Offline - Changes will sync when connected'
                    : 'Connection status unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
