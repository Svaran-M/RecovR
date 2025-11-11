import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../repositories/user_progress_repository.dart';
import '../repositories/local/local_user_progress_repository.dart';

final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return LocalUserProgressRepository();
});

class UserProgressNotifier extends StateNotifier<UserProgress> {
  final UserProgressRepository _repository;

  UserProgressNotifier(this._repository)
      : super(UserProgress(
          id: 'default',
          recoveryPoints: 0,
          currentLevel: 1,
          streakCount: 0,
          lastActivity: DateTime.now(),
          completionPercentage: 0.0,
        )) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _repository.get();
    if (progress != null) {
      state = progress;
    } else {
      await _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await _repository.save(state);
  }

  Future<void> addRecoveryPoints(int points) async {
    state = state.copyWith(
      recoveryPoints: state.recoveryPoints + points,
      lastActivity: DateTime.now(),
    );
    _checkLevelUp();
    await _saveProgress();
  }

  void _checkLevelUp() {
    final pointsForNextLevel = state.currentLevel * 100;
    if (state.recoveryPoints >= pointsForNextLevel) {
      state = state.copyWith(
        currentLevel: state.currentLevel + 1,
      );
    }
  }

  Future<void> incrementStreak() async {
    final now = DateTime.now();
    final lastActivity = state.lastActivity;
    final daysSinceLastActivity = now.difference(lastActivity).inDays;

    if (daysSinceLastActivity == 1) {
      state = state.copyWith(
        streakCount: state.streakCount + 1,
        lastActivity: now,
      );
    } else if (daysSinceLastActivity > 1) {
      state = state.copyWith(
        streakCount: 1,
        lastActivity: now,
      );
    }
    await _saveProgress();
  }

  Future<void> updateCompletionPercentage(double percentage) async {
    state = state.copyWith(
      completionPercentage: percentage,
      lastActivity: DateTime.now(),
    );
    await _saveProgress();
  }

  Future<void> resetProgress() async {
    state = UserProgress(
      id: state.id,
      recoveryPoints: 0,
      currentLevel: 1,
      streakCount: 0,
      lastActivity: DateTime.now(),
      completionPercentage: 0.0,
    );
    await _saveProgress();
  }
}

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return UserProgressNotifier(repository);
});
