import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehab_tracker_pro/providers/user_progress_provider.dart';
import 'package:rehab_tracker_pro/models/user_progress.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserProgressNotifier - State Updates', () {
    test('adds recovery points correctly', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).addRecoveryPoints(50);
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.recoveryPoints, 50);
      
      container.dispose();
    });

    test('levels up when reaching point threshold', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).addRecoveryPoints(100);
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.currentLevel, 2);
      expect(progress.recoveryPoints, 100);
      
      container.dispose();
    });

    test('increments streak on consecutive days', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final notifier = container.read(userProgressProvider.notifier);
      notifier.state = notifier.state.copyWith(lastActivity: yesterday);

      notifier.incrementStreak();
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.streakCount, 1);
      
      container.dispose();
    });

    test('resets streak when missing a day', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final notifier = container.read(userProgressProvider.notifier);
      notifier.state = notifier.state.copyWith(streakCount: 5);

      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      notifier.state = notifier.state.copyWith(lastActivity: threeDaysAgo);

      notifier.incrementStreak();
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.streakCount, 1);
      
      container.dispose();
    });

    test('updates completion percentage', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).updateCompletionPercentage(0.75);
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.completionPercentage, 0.75);
      
      container.dispose();
    });

    test('resets progress correctly', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final notifier = container.read(userProgressProvider.notifier);
      notifier.addRecoveryPoints(200);
      notifier.updateCompletionPercentage(0.8);
      await Future.delayed(const Duration(milliseconds: 300));

      notifier.resetProgress();
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.recoveryPoints, 0);
      expect(progress.currentLevel, 1);
      expect(progress.streakCount, 0);
      expect(progress.completionPercentage, 0.0);
      
      container.dispose();
    });
  });

  group('UserProgressNotifier - Persistence', () {
    test('persists data to shared_preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).addRecoveryPoints(150);
      await Future.delayed(const Duration(milliseconds: 300));

      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('user_progress');
      expect(savedData, isNotNull);
      expect(savedData, contains('150'));
      
      container.dispose();
    });
  });

  group('UserProgressNotifier - Edge Cases', () {
    test('handles negative points', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).addRecoveryPoints(-50);
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.recoveryPoints, -50);
      
      container.dispose();
    });

    test('handles completion percentage over 1.0', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      container.read(userProgressProvider.notifier).updateCompletionPercentage(1.5);
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = container.read(userProgressProvider);
      expect(progress.completionPercentage, 1.5);
      
      container.dispose();
    });
  });
}
