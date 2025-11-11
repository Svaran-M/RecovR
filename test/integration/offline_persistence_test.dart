import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/models/exercise.dart';
import 'package:rehab_tracker_pro/models/rom_measurement.dart';
import 'package:rehab_tracker_pro/models/symptom_log.dart';
import 'package:rehab_tracker_pro/models/user_progress.dart';
import 'package:rehab_tracker_pro/repositories/local/local_exercise_repository.dart';
import 'package:rehab_tracker_pro/repositories/local/local_rom_measurement_repository.dart';
import 'package:rehab_tracker_pro/repositories/local/local_symptom_log_repository.dart';
import 'package:rehab_tracker_pro/repositories/local/local_user_progress_repository.dart';
import 'package:rehab_tracker_pro/services/database/database_service.dart';
import 'package:rehab_tracker_pro/services/sync/sync_metadata_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FFI for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late LocalExerciseRepository exerciseRepo;
  late LocalROMMeasurementRepository romRepo;
  late LocalSymptomLogRepository symptomRepo;
  late LocalUserProgressRepository progressRepo;
  late SyncMetadataRepository syncRepo;

  setUp(() async {
    dbService = DatabaseService.instance;
    await dbService.deleteDatabase();
    
    exerciseRepo = LocalExerciseRepository();
    romRepo = LocalROMMeasurementRepository();
    symptomRepo = LocalSymptomLogRepository();
    progressRepo = LocalUserProgressRepository();
    syncRepo = SyncMetadataRepository();
  });

  tearDown(() async {
    await dbService.deleteDatabase();
  });

  group('Offline Data Persistence - Exercises', () {
    test('should persist exercise data locally', () async {
      final exercise = Exercise(
        id: 'ex1',
        name: 'Shoulder Rotation',
        description: 'Rotate shoulder clockwise',
        isCompleted: false,
        difficulty: Difficulty.medium,
        category: 'Shoulder',
      );

      await exerciseRepo.insert(exercise);
      final retrieved = await exerciseRepo.getById('ex1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, exercise.id);
      expect(retrieved.name, exercise.name);
      expect(retrieved.description, exercise.description);
    });

    test('should update exercise completion status offline', () async {
      final exercise = Exercise(
        id: 'ex2',
        name: 'Knee Bend',
        description: 'Bend knee slowly',
        isCompleted: false,
        difficulty: Difficulty.easy,
        category: 'Knee',
      );

      await exerciseRepo.insert(exercise);
      
      final updated = exercise.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await exerciseRepo.update(updated);

      final retrieved = await exerciseRepo.getById('ex2');
      expect(retrieved!.isCompleted, true);
      expect(retrieved.completedAt, isNotNull);
    });

    test('should retrieve all exercises from local storage', () async {
      final exercises = [
        Exercise(
          id: 'ex3',
          name: 'Exercise 1',
          description: 'Description 1',
          isCompleted: false,
          difficulty: Difficulty.easy,
          category: 'General',
        ),
        Exercise(
          id: 'ex4',
          name: 'Exercise 2',
          description: 'Description 2',
          isCompleted: true,
          difficulty: Difficulty.hard,
          category: 'General',
        ),
      ];

      for (final exercise in exercises) {
        await exerciseRepo.insert(exercise);
      }

      final retrieved = await exerciseRepo.getAll();
      expect(retrieved.length, 2);
    });

    test('should delete exercise from local storage', () async {
      final exercise = Exercise(
        id: 'ex5',
        name: 'To Delete',
        description: 'Will be deleted',
        isCompleted: false,
        difficulty: Difficulty.medium,
        category: 'Test',
      );

      await exerciseRepo.insert(exercise);
      await exerciseRepo.delete('ex5');

      final retrieved = await exerciseRepo.getById('ex5');
      expect(retrieved, isNull);
    });
  });

  group('Offline Data Persistence - ROM Measurements', () {
    test('should persist ROM measurement data locally', () async {
      final measurement = ROMMeasurement(
        id: 'rom1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 145.5,
        sessionNotes: 'Good progress',
      );

      await romRepo.insert(measurement);
      final retrieved = await romRepo.getById('rom1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, measurement.id);
      expect(retrieved.jointType, measurement.jointType);
      expect(retrieved.maxAngle, measurement.maxAngle);
      expect(retrieved.sessionNotes, measurement.sessionNotes);
    });

    test('should retrieve ROM measurements by joint type', () async {
      final measurements = [
        ROMMeasurement(
          id: 'rom2',
          date: DateTime.now(),
          jointType: 'shoulder',
          maxAngle: 140.0,
        ),
        ROMMeasurement(
          id: 'rom3',
          date: DateTime.now(),
          jointType: 'knee',
          maxAngle: 120.0,
        ),
        ROMMeasurement(
          id: 'rom4',
          date: DateTime.now(),
          jointType: 'shoulder',
          maxAngle: 145.0,
        ),
      ];

      for (final measurement in measurements) {
        await romRepo.insert(measurement);
      }

      final shoulderMeasurements = await romRepo.getByJointType('shoulder');
      expect(shoulderMeasurements.length, 2);
      expect(shoulderMeasurements.every((m) => m.jointType == 'shoulder'), true);
    });

    test('should retrieve ROM measurements by date range', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));

      final measurements = [
        ROMMeasurement(
          id: 'rom5',
          date: twoDaysAgo,
          jointType: 'shoulder',
          maxAngle: 140.0,
        ),
        ROMMeasurement(
          id: 'rom6',
          date: yesterday,
          jointType: 'knee',
          maxAngle: 120.0,
        ),
        ROMMeasurement(
          id: 'rom7',
          date: now,
          jointType: 'shoulder',
          maxAngle: 145.0,
        ),
      ];

      for (final measurement in measurements) {
        await romRepo.insert(measurement);
      }

      final recentMeasurements = await romRepo.getByDateRange(
        yesterday.subtract(const Duration(hours: 1)),
        now.add(const Duration(hours: 1)),
      );
      
      expect(recentMeasurements.length, 2);
    });
  });

  group('Offline Data Persistence - Symptom Logs', () {
    test('should persist symptom log data locally', () async {
      final symptomLog = SymptomLog(
        id: 'sym1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: true,
        notes: 'Feeling better',
      );

      await symptomRepo.insert(symptomLog);
      final retrieved = await symptomRepo.getById('sym1');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, symptomLog.id);
      expect(retrieved.painLevel, symptomLog.painLevel);
      expect(retrieved.swelling, symptomLog.swelling);
      expect(retrieved.medicationTaken, symptomLog.medicationTaken);
    });

    test('should retrieve symptom logs by date range', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final logs = [
        SymptomLog(
          id: 'sym2',
          date: yesterday,
          painLevel: 6,
          swelling: true,
          medicationTaken: true,
        ),
        SymptomLog(
          id: 'sym3',
          date: now,
          painLevel: 4,
          swelling: false,
          medicationTaken: false,
        ),
      ];

      for (final log in logs) {
        await symptomRepo.insert(log);
      }

      final recentLogs = await symptomRepo.getByDateRange(
        yesterday.subtract(const Duration(hours: 1)),
        now.add(const Duration(hours: 1)),
      );

      expect(recentLogs.length, 2);
    });
  });

  group('Offline Data Persistence - User Progress', () {
    test('should persist user progress data locally', () async {
      final progress = UserProgress(
        id: 'default',
        recoveryPoints: 150,
        currentLevel: 3,
        streakCount: 7,
        lastActivity: DateTime.now(),
        completionPercentage: 45.5,
      );

      await progressRepo.save(progress);
      final retrieved = await progressRepo.get();

      expect(retrieved, isNotNull);
      expect(retrieved!.recoveryPoints, progress.recoveryPoints);
      expect(retrieved.currentLevel, progress.currentLevel);
      expect(retrieved.streakCount, progress.streakCount);
    });

    test('should update user progress offline', () async {
      final progress = UserProgress(
        id: 'default',
        recoveryPoints: 100,
        currentLevel: 2,
        streakCount: 5,
        lastActivity: DateTime.now(),
        completionPercentage: 30.0,
      );

      await progressRepo.save(progress);

      final updated = progress.copyWith(
        recoveryPoints: 200,
        currentLevel: 3,
        streakCount: 6,
      );
      await progressRepo.save(updated);

      final retrieved = await progressRepo.get();
      expect(retrieved, isNotNull);
      expect(retrieved!.recoveryPoints, 200);
      expect(retrieved.currentLevel, 3);
      expect(retrieved.streakCount, 6);
    });
  });

  group('Offline Sync Metadata', () {
    test('should mark records for sync when offline', () async {
      await syncRepo.markForSync('exercises', 'ex1');
      
      final pending = await syncRepo.getPendingSync();
      expect(pending.length, 1);
      expect(pending.first.tableName, 'exercises');
      expect(pending.first.recordId, 'ex1');
      expect(pending.first.needsSync, true);
    });

    test('should track multiple pending sync records', () async {
      await syncRepo.markForSync('exercises', 'ex1');
      await syncRepo.markForSync('rom_measurements', 'rom1');
      await syncRepo.markForSync('symptom_logs', 'sym1');

      final pending = await syncRepo.getPendingSync();
      expect(pending.length, 3);
      
      final count = await syncRepo.getPendingCount();
      expect(count, 3);
    });

    test('should mark records as synced', () async {
      await syncRepo.markForSync('exercises', 'ex1');
      await syncRepo.markSynced('exercises', 'ex1');

      final pending = await syncRepo.getPendingSync();
      expect(pending.length, 0);
    });

    test('should increment sync attempts on failure', () async {
      await syncRepo.markForSync('exercises', 'ex1');
      await syncRepo.incrementSyncAttempts('exercises', 'ex1');
      await syncRepo.incrementSyncAttempts('exercises', 'ex1');

      final pending = await syncRepo.getPendingSync();
      expect(pending.first.syncAttempts, 2);
    });

    test('should clear all sync metadata', () async {
      await syncRepo.markForSync('exercises', 'ex1');
      await syncRepo.markForSync('exercises', 'ex2');
      await syncRepo.clearSyncMetadata();

      final pending = await syncRepo.getPendingSync();
      expect(pending.length, 0);
    });
  });

  group('Offline Data Persistence - Integration', () {
    test('should persist complete workout session offline', () async {
      // Create exercises
      final exercises = [
        Exercise(
          id: 'ex_session1',
          name: 'Warm Up',
          description: 'Light stretching',
          isCompleted: true,
          completedAt: DateTime.now(),
          difficulty: Difficulty.easy,
          category: 'Warm Up',
        ),
        Exercise(
          id: 'ex_session2',
          name: 'Main Exercise',
          description: 'Core workout',
          isCompleted: true,
          completedAt: DateTime.now(),
          difficulty: Difficulty.medium,
          category: 'Core',
        ),
      ];

      for (final exercise in exercises) {
        await exerciseRepo.insert(exercise);
        await syncRepo.markForSync('exercises', exercise.id);
      }

      // Add ROM measurement
      final romMeasurement = ROMMeasurement(
        id: 'rom_session1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 150.0,
        sessionNotes: 'Post-workout measurement',
      );
      await romRepo.insert(romMeasurement);
      await syncRepo.markForSync('rom_measurements', romMeasurement.id);

      // Add symptom log
      final symptomLog = SymptomLog(
        id: 'sym_session1',
        date: DateTime.now(),
        painLevel: 3,
        swelling: false,
        medicationTaken: false,
        notes: 'Feeling good after workout',
      );
      await symptomRepo.insert(symptomLog);
      await syncRepo.markForSync('symptom_logs', symptomLog.id);

      // Update progress
      final progress = UserProgress(
        id: 'default',
        recoveryPoints: 250,
        currentLevel: 4,
        streakCount: 10,
        lastActivity: DateTime.now(),
        completionPercentage: 60.0,
      );
      await progressRepo.save(progress);

      // Verify all data persisted
      final retrievedExercises = await exerciseRepo.getAll();
      expect(retrievedExercises.length, 2);

      final retrievedRom = await romRepo.getById('rom_session1');
      expect(retrievedRom, isNotNull);

      final retrievedSymptom = await symptomRepo.getById('sym_session1');
      expect(retrievedSymptom, isNotNull);

      final retrievedProgress = await progressRepo.get();
      expect(retrievedProgress, isNotNull);

      // Verify sync metadata (2 exercises + 1 ROM + 1 symptom = 4)
      final pendingSync = await syncRepo.getPendingSync();
      expect(pendingSync.length, 4);
    });

    test('should handle data persistence across app restarts', () async {
      // Simulate first session
      final exercise = Exercise(
        id: 'ex_restart1',
        name: 'Test Exercise',
        description: 'Test description',
        isCompleted: false,
        difficulty: Difficulty.medium,
        category: 'Test',
      );
      await exerciseRepo.insert(exercise);

      // Simulate app restart by getting new database instance
      final retrievedAfterRestart = await exerciseRepo.getById('ex_restart1');
      expect(retrievedAfterRestart, isNotNull);
      expect(retrievedAfterRestart!.name, exercise.name);
    });
  });
}
