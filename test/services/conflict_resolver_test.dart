import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/services/sync/conflict_resolver.dart';

class TestData {
  final String id;
  final String value;

  const TestData(this.id, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}

void main() {
  group('ConflictResolver - Local Wins Strategy', () {
    test('should always return local data', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.localWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().add(const Duration(hours: 1)),
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });

    test('should return local data even when remote is newer', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.localWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });
  });

  group('ConflictResolver - Remote Wins Strategy', () {
    test('should always return remote data', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.remoteWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now().add(const Duration(hours: 1)),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, remoteData);
    });

    test('should return remote data even when local is newer', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.remoteWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final result = resolver.resolve(conflict);
      expect(result, remoteData);
    });
  });

  group('ConflictResolver - Newer Wins Strategy', () {
    test('should return local data when local is newer', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });

    test('should return remote data when remote is newer', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, remoteData);
    });

    test('should return local data when timestamps are equal', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');
      final timestamp = DateTime.now();

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: timestamp,
        remoteTimestamp: timestamp,
      );

      final result = resolver.resolve(conflict);
      expect(result, remoteData);
    });

    test('should handle millisecond differences', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');
      final baseTime = DateTime.now();

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: baseTime.add(const Duration(milliseconds: 1)),
        remoteTimestamp: baseTime,
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });
  });

  group('ConflictResolver - Manual Strategy', () {
    test('should default to newer wins for manual strategy', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.manual,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });
  });

  group('ConflictResolver - Default Strategy', () {
    test('should use newer wins as default strategy', () {
      final resolver = ConflictResolver();

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, remoteData);
    });
  });

  group('ConflictResolver - Batch Resolution', () {
    test('should resolve multiple conflicts', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.localWins,
      );

      final conflicts = [
        DataConflict(
          localData: TestData('1', 'local1'),
          remoteData: TestData('1', 'remote1'),
          localTimestamp: DateTime.now(),
          remoteTimestamp: DateTime.now(),
        ),
        DataConflict(
          localData: TestData('2', 'local2'),
          remoteData: TestData('2', 'remote2'),
          localTimestamp: DateTime.now(),
          remoteTimestamp: DateTime.now(),
        ),
        DataConflict(
          localData: TestData('3', 'local3'),
          remoteData: TestData('3', 'remote3'),
          localTimestamp: DateTime.now(),
          remoteTimestamp: DateTime.now(),
        ),
      ];

      final results = resolver.resolveBatch(conflicts);

      expect(results.length, 3);
      expect(results[0], TestData('1', 'local1'));
      expect(results[1], TestData('2', 'local2'));
      expect(results[2], TestData('3', 'local3'));
    });

    test('should apply strategy consistently in batch', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final baseTime = DateTime.now();

      final conflicts = [
        DataConflict(
          localData: TestData('1', 'local1'),
          remoteData: TestData('1', 'remote1'),
          localTimestamp: baseTime.add(const Duration(hours: 1)),
          remoteTimestamp: baseTime,
        ),
        DataConflict(
          localData: TestData('2', 'local2'),
          remoteData: TestData('2', 'remote2'),
          localTimestamp: baseTime,
          remoteTimestamp: baseTime.add(const Duration(hours: 1)),
        ),
      ];

      final results = resolver.resolveBatch(conflicts);

      expect(results[0], TestData('1', 'local1'));
      expect(results[1], TestData('2', 'remote2'));
    });

    test('should handle empty batch', () {
      final resolver = ConflictResolver();

      final results = resolver.resolveBatch<TestData>([]);

      expect(results.isEmpty, true);
    });

    test('should handle single conflict in batch', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.remoteWins,
      );

      final conflicts = [
        DataConflict(
          localData: TestData('1', 'local'),
          remoteData: TestData('1', 'remote'),
          localTimestamp: DateTime.now(),
          remoteTimestamp: DateTime.now(),
        ),
      ];

      final results = resolver.resolveBatch(conflicts);

      expect(results.length, 1);
      expect(results[0], TestData('1', 'remote'));
    });
  });

  group('ConflictResolver - Different Data Types', () {
    test('should work with string data', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.localWins,
      );

      final conflict = DataConflict(
        localData: 'local string',
        remoteData: 'remote string',
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, 'local string');
    });

    test('should work with numeric data', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.remoteWins,
      );

      final conflict = DataConflict(
        localData: 42,
        remoteData: 100,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now(),
      );

      final result = resolver.resolve(conflict);
      expect(result, 100);
    });

    test('should work with map data', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localMap = {'key': 'local'};
      final remoteMap = {'key': 'remote'};

      final conflict = DataConflict(
        localData: localMap,
        remoteData: remoteMap,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final result = resolver.resolve(conflict);
      expect(result, localMap);
    });
  });

  group('ConflictResolver - Edge Cases', () {
    test('should handle very close timestamps', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final baseTime = DateTime.now();
      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: baseTime.add(const Duration(microseconds: 1)),
        remoteTimestamp: baseTime,
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });

    test('should handle far apart timestamps', () {
      final resolver = ConflictResolver(
        strategy: ConflictResolutionStrategy.newerWins,
      );

      final localData = TestData('1', 'local');
      final remoteData = TestData('1', 'remote');

      final conflict = DataConflict(
        localData: localData,
        remoteData: remoteData,
        localTimestamp: DateTime.now(),
        remoteTimestamp: DateTime.now().subtract(const Duration(days: 365)),
      );

      final result = resolver.resolve(conflict);
      expect(result, localData);
    });
  });
}
