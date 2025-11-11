import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rom_measurement.dart';
import '../repositories/rom_measurement_repository.dart';
import '../repositories/local/local_rom_measurement_repository.dart';

final romMeasurementRepositoryProvider =
    Provider<ROMMeasurementRepository>((ref) {
  return LocalROMMeasurementRepository();
});

class ROMMeasurementNotifier extends StateNotifier<List<ROMMeasurement>> {
  final ROMMeasurementRepository _repository;

  ROMMeasurementNotifier(this._repository) : super([]) {
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    state = await _repository.getAll();
  }

  Future<void> addMeasurement(ROMMeasurement measurement) async {
    await _repository.insert(measurement);
    state = [...state, measurement];
  }

  Future<void> removeMeasurement(String measurementId) async {
    await _repository.delete(measurementId);
    state = state.where((m) => m.id != measurementId).toList();
  }

  Future<void> updateMeasurement(ROMMeasurement updatedMeasurement) async {
    await _repository.update(updatedMeasurement);
    state = [
      for (final measurement in state)
        if (measurement.id == updatedMeasurement.id)
          updatedMeasurement
        else
          measurement,
    ];
  }

  List<ROMMeasurement> getMeasurementsForJoint(String jointType) {
    return state.where((m) => m.jointType == jointType).toList();
  }

  List<ROMMeasurement> getMeasurementsForDateRange(
      DateTime start, DateTime end) {
    return state.where((m) {
      return m.date.isAfter(start.subtract(const Duration(days: 1))) &&
          m.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  ROMMeasurement? getLatestMeasurement(String jointType) {
    final jointMeasurements = getMeasurementsForJoint(jointType);
    if (jointMeasurements.isEmpty) return null;
    return jointMeasurements.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  double? getAverageROM(String jointType, int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentMeasurements = state.where((m) {
      return m.jointType == jointType && m.date.isAfter(cutoffDate);
    }).toList();

    if (recentMeasurements.isEmpty) return null;

    final totalAngle = recentMeasurements.fold<double>(
        0.0, (sum, m) => sum + m.maxAngle);
    return totalAngle / recentMeasurements.length;
  }

  double? getImprovementPercentage(String jointType, int days) {
    final measurements = getMeasurementsForJoint(jointType);
    if (measurements.length < 2) return null;

    measurements.sort((a, b) => a.date.compareTo(b.date));

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentMeasurements =
        measurements.where((m) => m.date.isAfter(cutoffDate)).toList();

    if (recentMeasurements.isEmpty) return null;

    final firstAngle = recentMeasurements.first.maxAngle;
    final lastAngle = recentMeasurements.last.maxAngle;

    if (firstAngle == 0) return null;

    return ((lastAngle - firstAngle) / firstAngle) * 100;
  }
}

final romMeasurementProvider =
    StateNotifierProvider<ROMMeasurementNotifier, List<ROMMeasurement>>((ref) {
  final repository = ref.watch(romMeasurementRepositoryProvider);
  return ROMMeasurementNotifier(repository);
});
