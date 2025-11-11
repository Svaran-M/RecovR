# Integration Example: Adding Offline Sync to Your App

This guide shows how to integrate the offline sync features into your RehabTracker Pro app.

## Step 1: Initialize Services in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize settings service (required for sync preferences)
  await SettingsService.instance.init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## Step 2: Add Connection Status Indicator to App Shell

```dart
import 'package:flutter/material.dart';
import 'widgets/connection_status_indicator.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  
  const AppShell({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Shows banner when offline
          const ConnectionStatusIndicator(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
```

## Step 3: Add Sync Button to App Bar

```dart
import 'package:flutter/material.dart';
import 'widgets/sync_button.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          // Compact sync button in app bar
          SyncButton(compact: true),
        ],
      ),
      body: // Your dashboard content
    );
  }
}
```

## Step 4: Show Sync Status in Settings

```dart
import 'package:flutter/material.dart';
import 'features/settings/sync_settings_screen.dart';

// Add to your settings menu
ListTile(
  leading: const Icon(Icons.sync),
  title: const Text('Sync Settings'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SyncSettingsScreen(),
      ),
    );
  },
)
```

## Step 5: Monitor Sync Status in UI

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/sync_service.dart';
import 'widgets/sync_indicator.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    
    return Column(
      children: [
        // Show sync indicator
        const SyncIndicator(),
        
        // Or use geometric animation
        const GeometricSyncIndicator(),
        
        // React to sync status
        syncState.when(
          data: (state) {
            if (state.status == SyncStatus.syncing) {
              return const Text('Syncing your data...');
            }
            if (state.pendingChanges > 0) {
              return Text('${state.pendingChanges} changes pending');
            }
            return const Text('All synced!');
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Sync error'),
        ),
      ],
    );
  }
}
```

## Step 6: Trigger Sync After Important Actions

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/sync_service.dart';

class ExerciseCompletionButton extends ConsumerWidget {
  final String exerciseId;
  
  const ExerciseCompletionButton({required this.exerciseId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Complete the exercise
        await ref
            .read(exerciseProvider.notifier)
            .toggleExerciseCompletion(exerciseId);
        
        // Trigger sync if online
        final syncService = ref.read(syncServiceProvider);
        if (ref.read(connectivityServiceProvider).isOnline) {
          syncService.syncData();
        }
      },
      child: const Text('Complete Exercise'),
    );
  }
}
```

## Step 7: Show Connection-Aware UI

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/connectivity_service.dart';

class DataSyncButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    
    return connectionStatus.when(
      data: (status) {
        final isOnline = status == ConnectionStatus.online;
        
        return ElevatedButton(
          onPressed: isOnline
              ? () => ref.read(syncServiceProvider).syncData()
              : null,
          child: Row(
            children: [
              Icon(isOnline ? Icons.cloud_sync : Icons.cloud_off),
              const SizedBox(width: 8),
              Text(isOnline ? 'Sync Now' : 'Offline'),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error'),
    );
  }
}
```

## Step 8: Add Sync Settings Toggle

```dart
import 'package:flutter/material.dart';
import 'services/settings_service.dart';

class SyncSettingsWidget extends StatefulWidget {
  @override
  State<SyncSettingsWidget> createState() => _SyncSettingsWidgetState();
}

class _SyncSettingsWidgetState extends State<SyncSettingsWidget> {
  final _settings = SettingsService.instance;
  
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Auto Sync'),
      subtitle: const Text('Automatically sync when online'),
      value: _settings.getAutoSyncEnabled(),
      onChanged: (value) {
        setState(() {
          _settings.setAutoSyncEnabled(value);
        });
      },
    );
  }
}
```

## Complete Example: Dashboard with Sync

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/connection_status_indicator.dart';
import 'widgets/sync_button.dart';
import 'widgets/sync_indicator.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          SyncIndicator(showLabel: false),
          SizedBox(width: 8),
          SyncButton(compact: true),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          const ConnectionStatusIndicator(),
          
          // Main content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sync status card
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
                            const SyncIndicator(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        syncState.when(
                          data: (state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.lastSyncTime != null)
                                  Text(
                                    'Last synced: ${_formatTime(state.lastSyncTime!)}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                if (state.pendingChanges > 0)
                                  Text(
                                    '${state.pendingChanges} changes pending',
                                    style: const TextStyle(color: Colors.orange),
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
                
                // Your other dashboard widgets...
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
```

## Testing the Integration

1. **Test Offline Mode**:
   - Turn off WiFi/mobile data
   - Verify banner appears
   - Complete exercises
   - Verify data saves locally

2. **Test Online Mode**:
   - Turn on connectivity
   - Verify banner disappears
   - Tap sync button
   - Verify sync indicator animates

3. **Test Auto-Sync**:
   - Enable auto-sync in settings
   - Go offline and make changes
   - Go back online
   - Verify auto-sync triggers

## Troubleshooting

### Sync Not Working
- Check connectivity status
- Verify auto-sync is enabled
- Check for error messages in sync state

### Data Not Persisting
- Ensure database is initialized
- Check for database errors in logs
- Verify repository methods are called

### UI Not Updating
- Ensure using ConsumerWidget or Consumer
- Verify watching correct providers
- Check provider scope is at app root
