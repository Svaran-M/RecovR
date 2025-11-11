import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/services/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FFI for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    await dbService.deleteDatabase();
  });

  tearDown(() async {
    await dbService.deleteDatabase();
  });

  group('DatabaseService - Initialization', () {
    test('should initialize database successfully', () async {
      final db = await dbService.database;
      expect(db, isNotNull);
      expect(db.isOpen, true);
    });

    test('should return same database instance', () async {
      final db1 = await dbService.database;
      final db2 = await dbService.database;
      expect(identical(db1, db2), true);
    });

    test('should create all required tables', () async {
      final db = await dbService.database;
      
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
      );
      
      final tableNames = tables.map((t) => t['name'] as String).toList();
      
      expect(tableNames, contains('exercises'));
      expect(tableNames, contains('rom_measurements'));
      expect(tableNames, contains('symptom_logs'));
      expect(tableNames, contains('user_progress'));
      expect(tableNames, contains('sync_metadata'));
    });

    test('should create indexes for performance', () async {
      final db = await dbService.database;
      
      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%'",
      );
      
      final indexNames = indexes.map((i) => i['name'] as String).toList();
      
      expect(indexNames, contains('idx_exercises_completed'));
      expect(indexNames, contains('idx_rom_measurements_date'));
      expect(indexNames, contains('idx_rom_measurements_joint'));
      expect(indexNames, contains('idx_symptom_logs_date'));
      expect(indexNames, contains('idx_sync_metadata_needs_sync'));
    });
  });

  group('DatabaseService - Table Schema', () {
    test('should have correct exercises table schema', () async {
      final db = await dbService.database;
      
      final columns = await db.rawQuery('PRAGMA table_info(exercises)');
      final columnNames = columns.map((c) => c['name'] as String).toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('description'));
      expect(columnNames, contains('is_completed'));
      expect(columnNames, contains('completed_at'));
      expect(columnNames, contains('difficulty'));
      expect(columnNames, contains('category'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('should have correct rom_measurements table schema', () async {
      final db = await dbService.database;
      
      final columns = await db.rawQuery('PRAGMA table_info(rom_measurements)');
      final columnNames = columns.map((c) => c['name'] as String).toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('date'));
      expect(columnNames, contains('joint_type'));
      expect(columnNames, contains('max_angle'));
      expect(columnNames, contains('session_notes'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('should have correct symptom_logs table schema', () async {
      final db = await dbService.database;
      
      final columns = await db.rawQuery('PRAGMA table_info(symptom_logs)');
      final columnNames = columns.map((c) => c['name'] as String).toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('date'));
      expect(columnNames, contains('pain_level'));
      expect(columnNames, contains('swelling'));
      expect(columnNames, contains('medication_taken'));
      expect(columnNames, contains('notes'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });

    test('should have correct user_progress table schema', () async {
      final db = await dbService.database;
      
      final columns = await db.rawQuery('PRAGMA table_info(user_progress)');
      final columnNames = columns.map((c) => c['name'] as String).toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('recovery_points'));
      expect(columnNames, contains('current_level'));
      expect(columnNames, contains('streak_count'));
      expect(columnNames, contains('last_activity'));
      expect(columnNames, contains('completion_percentage'));
      expect(columnNames, contains('updated_at'));
    });

    test('should have correct sync_metadata table schema', () async {
      final db = await dbService.database;
      
      final columns = await db.rawQuery('PRAGMA table_info(sync_metadata)');
      final columnNames = columns.map((c) => c['name'] as String).toList();
      
      expect(columnNames, contains('id'));
      expect(columnNames, contains('table_name'));
      expect(columnNames, contains('record_id'));
      expect(columnNames, contains('last_synced'));
      expect(columnNames, contains('needs_sync'));
      expect(columnNames, contains('sync_attempts'));
      expect(columnNames, contains('created_at'));
      expect(columnNames, contains('updated_at'));
    });
  });

  group('DatabaseService - CRUD Operations', () {
    test('should insert data into exercises table', () async {
      final db = await dbService.database;
      
      final id = await db.insert('exercises', {
        'id': 'test1',
        'name': 'Test Exercise',
        'description': 'Test description',
        'is_completed': 0,
        'difficulty': 'medium',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      expect(id, greaterThan(0));
    });

    test('should query data from exercises table', () async {
      final db = await dbService.database;
      
      await db.insert('exercises', {
        'id': 'test2',
        'name': 'Query Test',
        'description': 'Query description',
        'is_completed': 0,
        'difficulty': 'easy',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      final results = await db.query(
        'exercises',
        where: 'id = ?',
        whereArgs: ['test2'],
      );
      
      expect(results.length, 1);
      expect(results.first['name'], 'Query Test');
    });

    test('should update data in exercises table', () async {
      final db = await dbService.database;
      
      await db.insert('exercises', {
        'id': 'test3',
        'name': 'Update Test',
        'description': 'Update description',
        'is_completed': 0,
        'difficulty': 'medium',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      final updateCount = await db.update(
        'exercises',
        {
          'is_completed': 1,
          'completed_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: ['test3'],
      );
      
      expect(updateCount, 1);
      
      final results = await db.query(
        'exercises',
        where: 'id = ?',
        whereArgs: ['test3'],
      );
      
      expect(results.first['is_completed'], 1);
    });

    test('should delete data from exercises table', () async {
      final db = await dbService.database;
      
      await db.insert('exercises', {
        'id': 'test4',
        'name': 'Delete Test',
        'description': 'Delete description',
        'is_completed': 0,
        'difficulty': 'hard',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      final deleteCount = await db.delete(
        'exercises',
        where: 'id = ?',
        whereArgs: ['test4'],
      );
      
      expect(deleteCount, 1);
      
      final results = await db.query(
        'exercises',
        where: 'id = ?',
        whereArgs: ['test4'],
      );
      
      expect(results.length, 0);
    });
  });

  group('DatabaseService - Transaction Support', () {
    test('should support transactions', () async {
      final db = await dbService.database;
      
      await db.transaction((txn) async {
        await txn.insert('exercises', {
          'id': 'txn1',
          'name': 'Transaction Test 1',
          'description': 'Test',
          'is_completed': 0,
          'difficulty': 'easy',
          'category': 'Test',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        await txn.insert('exercises', {
          'id': 'txn2',
          'name': 'Transaction Test 2',
          'description': 'Test',
          'is_completed': 0,
          'difficulty': 'medium',
          'category': 'Test',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      });
      
      final results = await db.query('exercises');
      expect(results.length, 2);
    });

    test('should rollback transaction on error', () async {
      final db = await dbService.database;
      
      try {
        await db.transaction((txn) async {
          await txn.insert('exercises', {
            'id': 'rollback1',
            'name': 'Rollback Test',
            'description': 'Test',
            'is_completed': 0,
            'difficulty': 'easy',
            'category': 'Test',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
          
          // Force an error
          throw Exception('Test error');
        });
      } catch (e) {
        // Expected error
      }
      
      final results = await db.query(
        'exercises',
        where: 'id = ?',
        whereArgs: ['rollback1'],
      );
      
      expect(results.length, 0);
    });
  });

  group('DatabaseService - Batch Operations', () {
    test('should support batch inserts', () async {
      final db = await dbService.database;
      
      final batch = db.batch();
      
      for (int i = 0; i < 5; i++) {
        batch.insert('exercises', {
          'id': 'batch$i',
          'name': 'Batch Exercise $i',
          'description': 'Batch test',
          'is_completed': 0,
          'difficulty': 'medium',
          'category': 'Test',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      
      await batch.commit();
      
      final results = await db.query('exercises');
      expect(results.length, 5);
    });

    test('should support batch updates', () async {
      final db = await dbService.database;
      
      // Insert test data
      for (int i = 0; i < 3; i++) {
        await db.insert('exercises', {
          'id': 'update$i',
          'name': 'Update Exercise $i',
          'description': 'Update test',
          'is_completed': 0,
          'difficulty': 'easy',
          'category': 'Test',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      
      // Batch update
      final batch = db.batch();
      for (int i = 0; i < 3; i++) {
        batch.update(
          'exercises',
          {'is_completed': 1},
          where: 'id = ?',
          whereArgs: ['update$i'],
        );
      }
      await batch.commit();
      
      final results = await db.query(
        'exercises',
        where: 'is_completed = ?',
        whereArgs: [1],
      );
      
      expect(results.length, 3);
    });
  });

  group('DatabaseService - Lifecycle', () {
    test('should close database connection', () async {
      final db = await dbService.database;
      expect(db.isOpen, true);
      
      await dbService.close();
      expect(db.isOpen, false);
    });

    test('should delete database file', () async {
      await dbService.database;
      await dbService.deleteDatabase();
      
      // After deletion, getting database should create new one
      final newDb = await dbService.database;
      expect(newDb.isOpen, true);
      
      // Should be empty
      final results = await newDb.query('exercises');
      expect(results.length, 0);
    });
  });

  group('DatabaseService - Error Handling', () {
    test('should handle invalid table queries gracefully', () async {
      final db = await dbService.database;
      
      expect(
        () => db.query('non_existent_table'),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should handle constraint violations', () async {
      final db = await dbService.database;
      
      await db.insert('exercises', {
        'id': 'constraint1',
        'name': 'Constraint Test',
        'description': 'Test',
        'is_completed': 0,
        'difficulty': 'easy',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      // Try to insert duplicate primary key
      expect(
        () => db.insert(
          'exercises',
          {
            'id': 'constraint1',
            'name': 'Duplicate',
            'description': 'Test',
            'is_completed': 0,
            'difficulty': 'easy',
            'category': 'Test',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        ),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should handle conflict with replace strategy', () async {
      final db = await dbService.database;
      
      await db.insert('exercises', {
        'id': 'replace1',
        'name': 'Original',
        'description': 'Original description',
        'is_completed': 0,
        'difficulty': 'easy',
        'category': 'Test',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      await db.insert(
        'exercises',
        {
          'id': 'replace1',
          'name': 'Replaced',
          'description': 'Replaced description',
          'is_completed': 1,
          'difficulty': 'hard',
          'category': 'Test',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      final results = await db.query(
        'exercises',
        where: 'id = ?',
        whereArgs: ['replace1'],
      );
      
      expect(results.length, 1);
      expect(results.first['name'], 'Replaced');
    });
  });
}
