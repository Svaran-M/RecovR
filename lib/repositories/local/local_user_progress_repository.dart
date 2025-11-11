import 'package:sqflite/sqflite.dart';
import '../../models/user_progress.dart';
import '../../services/database/database_service.dart';
import '../user_progress_repository.dart';

class LocalUserProgressRepository implements UserProgressRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String _defaultId = 'default';

  @override
  Future<UserProgress?> get() async {
    final db = await _dbService.database;
    final maps = await db.query(
      'user_progress',
      where: 'id = ?',
      whereArgs: [_defaultId],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<void> save(UserProgress progress) async {
    final db = await _dbService.database;
    await db.insert(
      'user_progress',
      _toMap(progress),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete() async {
    final db = await _dbService.database;
    await db.delete(
      'user_progress',
      where: 'id = ?',
      whereArgs: [_defaultId],
    );
  }

  Map<String, dynamic> _toMap(UserProgress progress) {
    return {
      'id': progress.id,
      'recovery_points': progress.recoveryPoints,
      'current_level': progress.currentLevel,
      'streak_count': progress.streakCount,
      'last_activity': progress.lastActivity.toIso8601String(),
      'completion_percentage': progress.completionPercentage,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserProgress _fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] as String,
      recoveryPoints: map['recovery_points'] as int,
      currentLevel: map['current_level'] as int,
      streakCount: map['streak_count'] as int,
      lastActivity: DateTime.parse(map['last_activity'] as String),
      completionPercentage: map['completion_percentage'] as double,
    );
  }
}
