import '../models/symptom_log.dart';

abstract class SymptomLogRepository {
  Future<List<SymptomLog>> getAll();
  Future<SymptomLog?> getById(String id);
  Future<List<SymptomLog>> getByDateRange(DateTime start, DateTime end);
  Future<void> insert(SymptomLog log);
  Future<void> update(SymptomLog log);
  Future<void> delete(String id);
  Future<void> deleteAll();
}
