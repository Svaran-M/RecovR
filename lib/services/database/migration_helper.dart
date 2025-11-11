import 'package:sqflite/sqflite.dart';

class MigrationHelper {
  // v1 to v2 migration (for future use)
  static Future<void> migrateV1ToV2(Database db) async {
    // await db.execute('ALTER TABLE exercises ADD COLUMN duration INTEGER');
  }

  // v2 to v3 migration (for future use)
  static Future<void> migrateV2ToV3(Database db) async {
    // create new tables or modify existing ones
  }

  static Future<bool> columnExists(
      Database db, String tableName, String columnName) async {
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    return result.any((column) => column['name'] == columnName);
  }

  static Future<bool> tableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> backupTable(
      Database db, String tableName) async {
    return await db.query(tableName);
  }

  static Future<void> restoreTable(
      Database db, String tableName, List<Map<String, dynamic>> data) async {
    final batch = db.batch();
    for (final row in data) {
      batch.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
