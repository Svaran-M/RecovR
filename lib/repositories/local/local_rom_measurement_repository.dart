import 'package:sqflite/sqflite.dart';
import '../../models/rom_measurement.dart';
import '../../services/database/database_service.dart';
import '../rom_measurement_repository.dart';

class LocalROMMeasurementRepository implements ROMMeasurementRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  Future<List<ROMMeasurement>> getAll() async {
    final db = await _dbService.database;
    final maps = await db.query('rom_measurements', orderBy: 'date DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<ROMMeasurement?> getById(String id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'rom_measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<List<ROMMeasurement>> getByJointType(String jointType) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'rom_measurements',
      where: 'joint_type = ?',
      whereArgs: [jointType],
      orderBy: 'date DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<List<ROMMeasurement>> getByDateRange(
      DateTime start, DateTime end) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'rom_measurements',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<void> insert(ROMMeasurement measurement) async {
    final db = await _dbService.database;
    await db.insert(
      'rom_measurements',
      _toMap(measurement),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(ROMMeasurement measurement) async {
    final db = await _dbService.database;
    await db.update(
      'rom_measurements',
      _toMap(measurement),
      where: 'id = ?',
      whereArgs: [measurement.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'rom_measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAll() async {
    final db = await _dbService.database;
    await db.delete('rom_measurements');
  }

  Map<String, dynamic> _toMap(ROMMeasurement measurement) {
    final now = DateTime.now().toIso8601String();
    return {
      'id': measurement.id,
      'date': measurement.date.toIso8601String(),
      'joint_type': measurement.jointType,
      'max_angle': measurement.maxAngle,
      'session_notes': measurement.sessionNotes,
      'created_at': now,
      'updated_at': now,
    };
  }

  ROMMeasurement _fromMap(Map<String, dynamic> map) {
    return ROMMeasurement(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      jointType: map['joint_type'] as String,
      maxAngle: map['max_angle'] as double,
      sessionNotes: map['session_notes'] as String?,
    );
  }
}
