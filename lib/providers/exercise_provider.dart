import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/local/local_exercise_repository.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return LocalExerciseRepository();
});

class ExerciseNotifier extends StateNotifier<List<Exercise>> {
  final ExerciseRepository _repository;

  ExerciseNotifier(this._repository) : super([]) {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await _repository.getAll();
    if (exercises.isEmpty) {
      await _initializeDefaultExercises();
    } else {
      state = exercises;
    }
  }

  Future<void> _initializeDefaultExercises() async {
    final defaultExercises = [
      Exercise(
        id: '1',
        name: 'Shoulder Flexion',
        description: 'Raise your arm forward and up',
        isCompleted: false,
        difficulty: Difficulty.easy,
        category: 'Upper Body',
      ),
      Exercise(
        id: '2',
        name: 'Knee Extension',
        description: 'Straighten your knee while seated',
        isCompleted: false,
        difficulty: Difficulty.medium,
        category: 'Lower Body',
      ),
      Exercise(
        id: '3',
        name: 'Ankle Rotation',
        description: 'Rotate your ankle in circles',
        isCompleted: false,
        difficulty: Difficulty.easy,
        category: 'Lower Body',
      ),
    ];

    for (final exercise in defaultExercises) {
      await _repository.insert(exercise);
    }
    state = defaultExercises;
  }

  Future<void> toggleExerciseCompletion(String exerciseId) async {
    final exercise = state.firstWhere((e) => e.id == exerciseId);
    final updated = exercise.copyWith(
      isCompleted: !exercise.isCompleted,
      completedAt: !exercise.isCompleted ? DateTime.now() : null,
    );

    await _repository.update(updated);
    state = [
      for (final e in state)
        if (e.id == exerciseId) updated else e,
    ];
  }

  Future<void> addExercise(Exercise exercise) async {
    await _repository.insert(exercise);
    state = [...state, exercise];
  }

  Future<void> removeExercise(String exerciseId) async {
    await _repository.delete(exerciseId);
    state = state.where((exercise) => exercise.id != exerciseId).toList();
  }

  Future<void> updateExercise(Exercise updatedExercise) async {
    await _repository.update(updatedExercise);
    state = [
      for (final exercise in state)
        if (exercise.id == updatedExercise.id) updatedExercise else exercise,
    ];
  }

  Future<void> resetDailyExercises() async {
    final resetExercises = state.map((exercise) {
      return exercise.copyWith(
        isCompleted: false,
        completedAt: null,
      );
    }).toList();

    for (final exercise in resetExercises) {
      await _repository.update(exercise);
    }
    state = resetExercises;
  }

  int get completedCount => state.where((e) => e.isCompleted).length;

  double get completionPercentage =>
      state.isEmpty ? 0.0 : completedCount / state.length;
}

final exerciseProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercise>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return ExerciseNotifier(repository);
});
