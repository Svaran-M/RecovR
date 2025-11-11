import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';

class SyncMetadata {
  final String id;
  final String tableName;
  final String recordId;
  final DateTime? lastSynced;
  final bool needsSync;
  final int syncAttempts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncMetadata({
    required this.id,
    required this.tableName,
    required this.recordId,
    this.lastSynced,
    required this.needsSync,
    required this.syncAttempts,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_name': tableName,
      'record_id': recordId,
      'last_synced': lastSynced?.toIso8601String(),
      'needs_sync': needsSync ? 1 : 0,
      'sync_attempts': syncAttempts,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SyncMetadata.fromMap(Map<String, dynamic> map) {
    return SyncMetadata(
      id: map['id'] as String,
      tableName: map['table_name'] as String,
      recordId: map['record_id'] as String,
      lastSynced: map['last_synced'] != null
          ? DateTime.parse(map['last_synced'] as String)
          : null,
      needsSync: (map['needs_sync'] as int) == 1,
      syncAttempts: map['sync_attempts'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class SyncMetadataRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<void> markForSync(String tableName, String recordId) async {
    final db = await _dbService.database;
    final id = '${tableName}_$recordId';
    final now = DateTime.now();

    await db.insert(
      'sync_metadata',
      {
        'id': id,
        'table_name': tableName,
        'record_id': recordId,
        'needs_sync': 1,
        'sync_attempts': 0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markSynced(String tableName, String recordId) async {
    final db = await _dbService.database;
    final id = '${tableName}_$recordId';

    await db.update(
      'sync_metadata',
      {
        'needs_sync': 0,
        'last_synced': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SyncMetadata>> getPendingSync() async {
    final db = await _dbService.database;
    final maps = await db.query(
      'sync_metadata',
      where: 'needs_sync = ?',
      whereArgs: [1],
      orderBy: 'created_at ASC',
    );

    return maps.map((map) => SyncMetadata.fromMap(map)).toList();
  }

  Future<int> getPendingCount() async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sync_metadata WHERE needs_sync = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> incrementSyncAttempts(String tableName, String recordId) async {
    final db = await _dbService.database;
    final id = '${tableName}_$recordId';

    await db.rawUpdate(
      'UPDATE sync_metadata SET sync_attempts = sync_attempts + 1, updated_at = ? WHERE id = ?',
      [DateTime.now().toIso8601String(), id],
    );
  }

  Future<void> clearSyncMetadata() async {
    final db = await _dbService.database;
    await db.delete('sync_metadata');
  }
}
