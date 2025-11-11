import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';

class SyncButton extends ConsumerWidget {
  final bool compact;

  const SyncButton({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);

    return syncState.when(
      data: (state) {
        final isOnline = connectionStatus.value == ConnectionStatus.online;
        final isSyncing = state.status == SyncStatus.syncing;

        return compact
            ? IconButton(
                icon: Icon(
                  isSyncing ? Icons.sync : Icons.cloud_sync,
                  color: isOnline
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: isOnline && !isSyncing
                    ? () => ref.read(syncServiceProvider).syncData()
                    : null,
                tooltip: isOnline ? 'Sync data' : 'Offline',
              )
            : ElevatedButton.icon(
                onPressed: isOnline && !isSyncing
                    ? () => ref.read(syncServiceProvider).syncData()
                    : null,
                icon: Icon(isSyncing ? Icons.sync : Icons.cloud_sync),
                label: Text(isSyncing ? 'Syncing...' : 'Sync Now'),
              );
      },
      loading: () => compact
          ? const IconButton(
              icon: Icon(Icons.cloud_sync),
              onPressed: null,
            )
          : const ElevatedButton(
              onPressed: null,
              child: Text('Loading...'),
            ),
      error: (_, __) => compact
          ? const IconButton(
              icon: Icon(Icons.error),
              onPressed: null,
            )
          : const ElevatedButton(
              onPressed: null,
              child: Text('Error'),
            ),
    );
  }
}
