import '../models/rom_measurement.dart';

abstract class ROMMeasurementRepository {
  Future<List<ROMMeasurement>> getAll();
  Future<ROMMeasurement?> getById(String id);
  Future<List<ROMMeasurement>> getByJointType(String jointType);
  Future<List<ROMMeasurement>> getByDateRange(DateTime start, DateTime end);
  Future<void> insert(ROMMeasurement measurement);
  Future<void> update(ROMMeasurement measurement);
  Future<void> delete(String id);
  Future<void> deleteAll();
}
