import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/sync_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/settings_service.dart';
import '../../widgets/sync_button.dart';
import '../../widgets/sync_indicator.dart';
import '../../widgets/connection_status_indicator.dart';

class SyncSettingsScreen extends ConsumerWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);
    final settingsService = SettingsService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Settings'),
        actions: const [
          SyncButton(compact: true),
        ],
      ),
      body: Column(
        children: [
          const ConnectionStatusIndicator(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Connection Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wifi),
                            const SizedBox(width: 12),
                            const Text(
                              'Connection Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        connectionStatus.when(
                          data: (status) {
                            final isOnline =
                                status == ConnectionStatus.online;
                            return Row(
                              children: [
                                Icon(
                                  isOnline
                                      ? Icons.check_circle
                                      : Icons.cloud_off,
                                  color: isOnline ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: TextStyle(
                                    color: isOnline ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text('Error'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sync Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sync),
                            const SizedBox(width: 12),
                            const Text(
                              'Sync Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const SyncIndicator(showLabel: false),
                          ],
                        ),
                        const SizedBox(height: 16),
                        syncState.when(
                          data: (state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  'Status',
                                  _getStatusText(state.status),
                                ),
                                const SizedBox(height: 8),
                                if (state.lastSyncTime != null)
                                  _buildInfoRow(
                                    'Last Sync',
                                    _formatDateTime(state.lastSyncTime!),
                                  ),
                                const SizedBox(height: 8),
                                if (state.pendingChanges > 0)
                                  _buildInfoRow(
                                    'Pending Changes',
                                    '${state.pendingChanges}',
                                  ),
                                if (state.errorMessage != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error: ${state.errorMessage}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ],
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text('Error loading sync status'),
                        ),
                        const SizedBox(height: 16),
                        const SyncButton(compact: false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sync Settings Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 12),
                            Text(
                              'Sync Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Auto Sync'),
                          subtitle: const Text(
                            'Automatically sync when connected to internet',
                          ),
                          value: settingsService.getAutoSyncEnabled(),
                          onChanged: (value) {
                            settingsService.setAutoSyncEnabled(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Geometric Sync Indicator Demo
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.animation),
                            SizedBox(width: 12),
                            Text(
                              'Geometric Sync Animation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: GeometricSyncIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return 'Idle';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.success:
        return 'Success';
      case SyncStatus.error:
        return 'Error';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
