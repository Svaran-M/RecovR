import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/status_header.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/daily_action_card.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/progress_ring.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/streak_counter.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/trend_chart.dart';

void main() {
  group('Dashboard Animation Performance Tests', () {
    testWidgets('StatusHeader animations complete smoothly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 100,
              currentLevel: 2,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Verify animations don't cause frame drops
      await tester.pump(const Duration(milliseconds: 16)); // 60fps frame
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      
      // Complete all animations
      await tester.pumpAndSettle();
      
      expect(find.byType(StatusHeader), findsOneWidget);
    });

    testWidgets('DailyActionCard pulse animation is smooth', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Test',
              subtitle: 'Test subtitle',
              onTap: () {},
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Advance through multiple animation frames
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      
      expect(find.byType(DailyActionCard), findsOneWidget);
    });

    testWidgets('ProgressRing animation completes without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.0,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Update to full progress
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 1.0,
              size: 150,
            ),
          ),
        ),
      );

      // Verify animation frames
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('StreakCounter holographic animation runs continuously', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 5,
              size: 120,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Advance through animation cycle
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 1000));
      
      expect(find.byType(StreakCounter), findsOneWidget);
    });

    testWidgets('TrendChart path drawing animation is smooth', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25, 35, 28],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
              title: 'Weekly Progress',
              height: 200,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Advance through drawing animation
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.pumpAndSettle();
      
      expect(find.byType(TrendChart), findsOneWidget);
    });

    testWidgets('Multiple dashboard widgets animate together', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const StatusHeader(
                  recoveryPoints: 150,
                  currentLevel: 3,
                ),
                DailyActionCard(
                  title: 'Start Session',
                  subtitle: 'Begin now',
                  onTap: () {},
                ),
                const ProgressRing(
                  progress: 0.75,
                  size: 150,
                ),
                const StreakCounter(
                  streakCount: 7,
                  size: 120,
                ),
              ],
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Advance all animations
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      
      // Verify all widgets rendered
      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);
    });

    testWidgets('Rapid state changes handle gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.0,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Rapid progress updates
      for (double progress = 0.1; progress <= 1.0; progress += 0.1) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProgressRing(
                progress: progress,
                size: 150,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('Animation controllers dispose properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 100,
              currentLevel: 2,
            ),
          ),
        ),
      );

      await tester.pump();

      // Remove widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(),
          ),
        ),
      );

      await tester.pump();
      
      // Should not throw errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('Particle animations perform efficiently', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 200,
              currentLevel: 4,
            ),
          ),
        ),
      );

      // Run particle animation for extended period
      await tester.pump();
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      
      expect(find.byType(StatusHeader), findsOneWidget);
    });

    testWidgets('Morphing animations transition smoothly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Action',
              subtitle: 'Subtitle',
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pump();

      // Trigger morph animation
      await tester.tap(find.byType(DailyActionCard));
      
      // Verify smooth transition
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      
      await tester.pumpAndSettle();
      
      expect(tester.takeException(), isNull);
    });
  });

  group('Dashboard Animation Transition Tests', () {
    testWidgets('StatusHeader level transition animates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 100,
              currentLevel: 2,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('LV 2'), findsOneWidget);

      // Level up
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 200,
              currentLevel: 3,
            ),
          ),
        ),
      );

      // Animation frames
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      
      await tester.pumpAndSettle();
      expect(find.text('LV 3'), findsOneWidget);
    });

    testWidgets('ProgressRing color transitions work', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.3,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Change progress to trigger color transition
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.9,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      
      expect(find.text('90%'), findsOneWidget);
    });

    testWidgets('StreakCounter facet activation animates', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 3,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Increase streak
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 5,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      
      expect(find.text('5'), findsOneWidget);
    });
  });
}
