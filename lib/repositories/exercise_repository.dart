import '../models/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
  Future<void> insert(Exercise exercise);
  Future<void> update(Exercise exercise);
  Future<void> delete(String id);
  Future<void> deleteAll();
  Future<int> getCompletedCount();
}
