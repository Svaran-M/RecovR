import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rehab_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        difficulty TEXT NOT NULL,
        category TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rom_measurements (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        joint_type TEXT NOT NULL,
        max_angle REAL NOT NULL,
        session_notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE symptom_logs (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        pain_level INTEGER NOT NULL,
        swelling INTEGER NOT NULL,
        medication_taken INTEGER NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_progress (
        id TEXT PRIMARY KEY,
        recovery_points INTEGER NOT NULL,
        current_level INTEGER NOT NULL,
        streak_count INTEGER NOT NULL,
        last_activity TEXT NOT NULL,
        completion_percentage REAL NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // tracks what needs syncing
    await db.execute('''
      CREATE TABLE sync_metadata (
        id TEXT PRIMARY KEY,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        last_synced TEXT,
        needs_sync INTEGER NOT NULL DEFAULT 1,
        sync_attempts INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // indexes for faster queries
    await db.execute(
        'CREATE INDEX idx_exercises_completed ON exercises(is_completed)');
    await db.execute(
        'CREATE INDEX idx_rom_measurements_date ON rom_measurements(date)');
    await db.execute(
        'CREATE INDEX idx_rom_measurements_joint ON rom_measurements(joint_type)');
    await db.execute(
        'CREATE INDEX idx_symptom_logs_date ON symptom_logs(date)');
    await db.execute(
        'CREATE INDEX idx_sync_metadata_needs_sync ON sync_metadata(needs_sync)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // migrations go here when needed
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE exercises ADD COLUMN new_field TEXT');
    // }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rehab_tracker.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
