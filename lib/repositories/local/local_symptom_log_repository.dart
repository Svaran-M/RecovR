import 'package:sqflite/sqflite.dart';
import '../../models/symptom_log.dart';
import '../../services/database/database_service.dart';
import '../symptom_log_repository.dart';

class LocalSymptomLogRepository implements SymptomLogRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  Future<List<SymptomLog>> getAll() async {
    final db = await _dbService.database;
    final maps = await db.query('symptom_logs', orderBy: 'date DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<SymptomLog?> getById(String id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'symptom_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<List<SymptomLog>> getByDateRange(DateTime start, DateTime end) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'symptom_logs',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<void> insert(SymptomLog log) async {
    final db = await _dbService.database;
    await db.insert(
      'symptom_logs',
      _toMap(log),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(SymptomLog log) async {
    final db = await _dbService.database;
    await db.update(
      'symptom_logs',
      _toMap(log),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'symptom_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAll() async {
    final db = await _dbService.database;
    await db.delete('symptom_logs');
  }

  Map<String, dynamic> _toMap(SymptomLog log) {
    final now = DateTime.now().toIso8601String();
    return {
      'id': log.id,
      'date': log.date.toIso8601String(),
      'pain_level': log.painLevel,
      'swelling': log.swelling ? 1 : 0,
      'medication_taken': log.medicationTaken ? 1 : 0,
      'notes': log.notes,
      'created_at': now,
      'updated_at': now,
    };
  }

  SymptomLog _fromMap(Map<String, dynamic> map) {
    return SymptomLog(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      painLevel: map['pain_level'] as int,
      swelling: (map['swelling'] as int) == 1,
      medicationTaken: (map['medication_taken'] as int) == 1,
      notes: map['notes'] as String?,
    );
  }
}
