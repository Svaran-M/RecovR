import 'package:sqflite/sqflite.dart';
import '../../models/exercise.dart';
import '../../services/database/database_service.dart';
import '../exercise_repository.dart';

class LocalExerciseRepository implements ExerciseRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  Future<List<Exercise>> getAll() async {
    final db = await _dbService.database;
    final maps = await db.query('exercises', orderBy: 'created_at DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<Exercise?> getById(String id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<void> insert(Exercise exercise) async {
    final db = await _dbService.database;
    await db.insert(
      'exercises',
      _toMap(exercise),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(Exercise exercise) async {
    final db = await _dbService.database;
    await db.update(
      'exercises',
      _toMap(exercise),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAll() async {
    final db = await _dbService.database;
    await db.delete('exercises');
  }

  @override
  Future<int> getCompletedCount() async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM exercises WHERE is_completed = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Map<String, dynamic> _toMap(Exercise exercise) {
    final now = DateTime.now().toIso8601String();
    return {
      'id': exercise.id,
      'name': exercise.name,
      'description': exercise.description,
      'is_completed': exercise.isCompleted ? 1 : 0,
      'completed_at': exercise.completedAt?.toIso8601String(),
      'difficulty': exercise.difficulty.name,
      'category': exercise.category,
      'created_at': now,
      'updated_at': now,
    };
  }

  Exercise _fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      category: map['category'] as String,
    );
  }
}
