# Offline Functionality Tests

This directory contains tests for the offline functionality and data synchronization features of RehabTracker Pro.

## Test Coverage

### ✅ Completed Tests

#### 1. Connectivity Service Tests (`connectivity_service_test.dart`)
Tests the connection status detection and handling:
- Connection status initialization and detection
- Online/offline status reporting
- Status stream management and broadcasting
- Multiple stream listeners support
- Stream lifecycle (dispose handling)
- Error handling and recovery
- State consistency between getters and streams

**Test Count:** 12 tests
**Status:** All passing

#### 2. Conflict Resolver Tests (`conflict_resolver_test.dart`)
Tests the data conflict resolution strategies for sync:
- Local wins strategy
- Remote wins strategy
- Newer wins strategy (default)
- Manual strategy (defaults to newer wins)
- Batch conflict resolution
- Different data types (strings, numbers, maps, custom objects)
- Edge cases (close timestamps, far apart timestamps)
- Millisecond-level timestamp precision

**Test Count:** 19 tests
**Status:** All passing

### 📝 Test Limitations

Due to Flutter's testing environment limitations, the following tests require integration testing or device/emulator execution:

#### Database Operations
- **Reason:** `sqflite` requires platform-specific implementation
- **Alternative:** Would need `sqflite_common_ffi` package for unit testing
- **Coverage Needed:**
  - Exercise CRUD operations
  - ROM measurement storage and retrieval
  - Symptom log persistence
  - User progress tracking
  - Data migration strategies
  - Transaction handling
  - Concurrent operations

#### Sync Service
- **Reason:** Depends on `shared_preferences` which requires platform channels
- **Alternative:** Would need mocking or integration tests
- **Coverage Needed:**
  - Sync state management
  - Pending changes tracking
  - Auto-sync functionality
  - Sync error handling
  - Last sync time persistence
  - State stream emissions

#### Sync Metadata Repository
- **Reason:** Depends on database service
- **Alternative:** Integration tests with real database
- **Coverage Needed:**
  - Marking records for sync
  - Tracking sync attempts
  - Pending sync queries
  - Sync metadata cleanup

## Test Execution

### Run All Service Tests
```bash
flutter test test/services/
```

### Run Specific Test File
```bash
flutter test test/services/connectivity_service_test.dart
flutter test test/services/conflict_resolver_test.dart
```

### Run with Coverage
```bash
flutter test --coverage test/services/
```

## Integration Test Recommendations

For comprehensive offline functionality testing, the following integration tests should be implemented:

### 1. End-to-End Offline Workflow
```dart
// Pseudo-code for integration test
testWidgets('user can work offline and sync when online', (tester) async {
  // 1. Start app while online
  // 2. Create exercises, log symptoms, record ROM measurements
  // 3. Go offline (simulate)
  // 4. Continue making changes
  // 5. Verify data persists locally
  // 6. Go back online
  // 7. Trigger sync
  // 8. Verify all changes synced
});
```

### 2. Data Persistence Across App Restarts
```dart
testWidgets('data persists across app restarts', (tester) async {
  // 1. Create data
  // 2. Close app
  // 3. Reopen app
  // 4. Verify data still exists
});
```

### 3. Conflict Resolution in Practice
```dart
testWidgets('conflicts are resolved correctly', (tester) async {
  // 1. Make changes on device A
  // 2. Make conflicting changes on device B
  // 3. Sync both devices
  // 4. Verify conflict resolution strategy applied
});
```

### 4. Sync Indicator UI
```dart
testWidgets('sync indicators show correct state', (tester) async {
  // 1. Verify idle state
  // 2. Trigger sync
  // 3. Verify syncing state
  // 4. Verify success/error states
});
```

## Manual Testing Checklist

For features that cannot be easily automated:

- [ ] App works completely offline
- [ ] Data persists after app restart
- [ ] Sync triggers automatically when coming online (if enabled)
- [ ] Manual sync button works
- [ ] Sync indicators show correct states
- [ ] Pending changes counter is accurate
- [ ] Last sync time displays correctly
- [ ] Auto-sync setting persists
- [ ] Connection status indicator is accurate
- [ ] Offline changes sync successfully when online
- [ ] No data loss during sync
- [ ] Conflict resolution works as expected
- [ ] Database migrations work correctly
- [ ] Performance is acceptable with large datasets

## Requirements Coverage

This test suite covers the following requirements from the spec:

### Requirement 5.2: Data Persistence
- ✅ Connection status detection
- ✅ Conflict resolution strategies
- ⚠️ Local data storage (needs integration tests)
- ⚠️ Sync state management (needs integration tests)

### Requirement 5.5: Offline Support
- ✅ Connection status monitoring
- ✅ Offline/online state detection
- ⚠️ Offline data operations (needs integration tests)
- ⚠️ Sync when connection restored (needs integration tests)

## Notes

- All unit tests use `TestWidgetsFlutterBinding.ensureInitialized()` to properly initialize Flutter bindings
- Connectivity tests account for actual network state and may behave differently in different environments
- Async operations include appropriate delays to ensure state changes complete
- Stream tests properly clean up subscriptions to avoid memory leaks
- Tests are isolated and can run in any order

## Future Improvements

1. Add mock implementations for `shared_preferences` to enable sync service unit tests
2. Add `sqflite_common_ffi` dependency for database unit tests
3. Create integration test suite for end-to-end offline workflows
4. Add performance tests for large datasets
5. Add stress tests for rapid state changes
6. Add tests for edge cases (app killed during sync, etc.)
