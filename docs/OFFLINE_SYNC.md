# Offline Support and Data Synchronization

This document describes the offline support and data synchronization architecture implemented in RehabTracker Pro.

## Architecture Overview

The app uses a **local-first architecture** with the following components:

### 1. Local Data Persistence

- **SQLite Database** (`sqflite`): Stores all user data locally
- **Shared Preferences**: Stores user settings and preferences
- **Repository Pattern**: Clean abstraction layer for data access

### 2. Data Layers

```
UI Layer (Widgets)
    ↓
State Management (Riverpod Providers)
    ↓
Repository Interface (Abstract)
    ↓
Local Repository Implementation (SQLite)
    ↓
Database Service (sqflite)
```

## Key Components

### Database Service

**Location**: `lib/services/database/database_service.dart`

- Manages SQLite database connection
- Handles database creation and migrations
- Provides singleton instance

**Tables**:
- `exercises`: User's exercise data
- `rom_measurements`: Range of motion measurements
- `symptom_logs`: Symptom tracking data
- `user_progress`: Gamification progress
- `sync_metadata`: Tracks sync status of records

### Repository Pattern

**Interfaces** (in `lib/repositories/`):
- `ExerciseRepository`
- `ROMMeasurementRepository`
- `SymptomLogRepository`
- `UserProgressRepository`

**Local Implementations** (in `lib/repositories/local/`):
- `LocalExerciseRepository`
- `LocalROMMeasurementRepository`
- `LocalSymptomLogRepository`
- `LocalUserProgressRepository`

### Connectivity Service

**Location**: `lib/services/connectivity_service.dart`

- Monitors network connectivity using `connectivity_plus`
- Provides real-time connection status updates
- Exposes `ConnectionStatus` enum: `online`, `offline`, `unknown`

### Sync Service

**Location**: `lib/services/sync_service.dart`

- Manages data synchronization
- Tracks sync status and pending changes
- Supports auto-sync when connection is restored
- Provides `SyncStatus` enum: `idle`, `syncing`, `success`, `error`

### Settings Service

**Location**: `lib/services/settings_service.dart`

- Manages user preferences using `shared_preferences`
- Stores sync settings (auto-sync enabled, last sync time)
- Stores app preferences (theme, notifications, etc.)

## UI Components

### Connection Status Indicator

**Location**: `lib/widgets/connection_status_indicator.dart`

- Shows banner when offline
- Automatically hides when online
- Provides visual feedback about connection state

### Sync Indicator

**Location**: `lib/widgets/sync_indicator.dart`

- Shows sync status with icon and label
- Animated rotation during sync
- Two variants:
  - `SyncIndicator`: Standard indicator with label
  - `GeometricSyncIndicator`: Unique geometric animation

### Sync Button

**Location**: `lib/widgets/sync_button.dart`

- Manual sync trigger
- Disabled when offline or already syncing
- Available in compact (icon) and full (button) modes

### Sync Settings Screen

**Location**: `lib/features/settings/sync_settings_screen.dart`

- Complete sync management UI
- Shows connection status
- Displays sync status and last sync time
- Allows toggling auto-sync
- Manual sync trigger

## Data Flow

### Writing Data (Offline-First)

1. User performs action (e.g., completes exercise)
2. Provider updates state
3. Repository saves to local SQLite database
4. Sync metadata marks record as needing sync
5. UI updates immediately (no waiting for network)
6. When online, sync service uploads changes

### Reading Data

1. Provider loads data from repository on initialization
2. Repository queries local SQLite database
3. Data is immediately available (no network required)
4. UI displays data

### Synchronization (Future Implementation)

When implementing cloud sync (e.g., with Supabase):

1. Check connectivity status
2. Query sync metadata for pending changes
3. Upload local changes to cloud
4. Download remote changes
5. Resolve conflicts using `ConflictResolver`
6. Update local database
7. Mark records as synced
8. Update last sync time

## Conflict Resolution

**Location**: `lib/services/sync/conflict_resolver.dart`

Supports multiple strategies:
- `localWins`: Local data takes precedence
- `remoteWins`: Remote data takes precedence
- `newerWins`: Most recent timestamp wins (default)
- `manual`: User resolves conflicts (future)

## Migration Strategy

The architecture is designed for easy migration to cloud sync:

### Current State (Local Only)
```dart
Provider → LocalRepository → SQLite
```

### Future State (With Supabase)
```dart
Provider → SupabaseRepository → Supabase + Local Cache
```

### Migration Steps

1. **Create Supabase Repository**:
   ```dart
   class SupabaseExerciseRepository implements ExerciseRepository {
     // Implement interface using Supabase client
   }
   ```

2. **Update Provider**:
   ```dart
   final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
     return SupabaseExerciseRepository(); // Changed from Local
   });
   ```

3. **No Changes Needed**:
   - Providers remain unchanged
   - UI components remain unchanged
   - Business logic remains unchanged

## Database Migrations

**Location**: `lib/services/database/migration_helper.dart`

Provides utilities for:
- Adding columns
- Creating tables
- Checking table/column existence
- Backing up and restoring data

### Adding a Migration

```dart
Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE exercises ADD COLUMN duration INTEGER');
  }
  if (oldVersion < 3) {
    await MigrationHelper.migrateV2ToV3(db);
  }
}
```

## Usage Examples

### Initialize Services

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize settings service
  await SettingsService.instance.init();
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Monitor Connection Status

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    
    return connectionStatus.when(
      data: (status) => Text('Status: $status'),
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Text('Error'),
    );
  }
}
```

### Trigger Manual Sync

```dart
ElevatedButton(
  onPressed: () {
    ref.read(syncServiceProvider).syncData();
  },
  child: Text('Sync Now'),
)
```

### Check Sync Status

```dart
final syncState = ref.watch(syncStateProvider);

syncState.when(
  data: (state) {
    if (state.status == SyncStatus.syncing) {
      return CircularProgressIndicator();
    }
    return Text('Last sync: ${state.lastSyncTime}');
  },
  loading: () => CircularProgressIndicator(),
  error: (_, __) => Text('Error'),
);
```

## Testing

### Unit Tests

Test repositories independently:

```dart
test('LocalExerciseRepository saves exercise', () async {
  final repo = LocalExerciseRepository();
  final exercise = Exercise(...);
  
  await repo.insert(exercise);
  final retrieved = await repo.getById(exercise.id);
  
  expect(retrieved, equals(exercise));
});
```

### Integration Tests

Test sync flow:

```dart
testWidgets('Sync button triggers sync', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(SyncButton));
  await tester.pump();
  
  expect(find.text('Syncing...'), findsOneWidget);
});
```

## Performance Considerations

1. **Indexes**: Database tables have indexes on frequently queried columns
2. **Batch Operations**: Use batch inserts for multiple records
3. **Lazy Loading**: Data loaded on demand, not all at once
4. **Connection Pooling**: Single database instance reused

## Security Considerations

1. **Local Data**: SQLite database is sandboxed per platform
2. **Encryption**: Consider using `sqflite_sqlcipher` for encrypted database
3. **Sync Authentication**: Future cloud sync will require authentication
4. **Data Validation**: Validate data before saving

## Future Enhancements

1. **Supabase Integration**: Replace local-only with cloud sync
2. **Real-time Sync**: Use Supabase real-time subscriptions
3. **Selective Sync**: Allow users to choose what to sync
4. **Conflict UI**: Manual conflict resolution interface
5. **Sync History**: Track sync history and changes
6. **Background Sync**: Sync in background using WorkManager
7. **Compression**: Compress data before upload
8. **Delta Sync**: Only sync changed fields, not entire records
