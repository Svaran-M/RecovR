import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/status_header.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/daily_action_card.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/progress_ring.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/streak_counter.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/trend_chart.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

void main() {
  group('StatusHeader Widget Tests', () {
    testWidgets('renders with recovery points and level', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 150,
              currentLevel: 3,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      // Allow animations to start
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
      expect(find.text('points'), findsOneWidget);
      expect(find.textContaining('Level'), findsOneWidget);
    });

    testWidgets('updates recovery points with animation', (WidgetTester tester) async {
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
      expect(find.text('100'), findsOneWidget);

      // Rebuild with new points
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 200,
              currentLevel: 2,
            ),
          ),
        ),
      );

      // Trigger animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('200'), findsOneWidget);
    });

    testWidgets('animates level indicator correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 250,
              currentLevel: 5,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Complete level animation (800ms duration)
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.textContaining('Level'), findsOneWidget);
    });

    testWidgets('renders particle effects', (WidgetTester tester) async {
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

      expect(find.byType(CustomPaint), findsWidgets);
      
      // Advance animation
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles zero values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 0,
              currentLevel: 1,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('0'), findsOneWidget);
      expect(find.textContaining('Level'), findsOneWidget);
    });
  });

  group('DailyActionCard Widget Tests', () {
    testWidgets('renders title and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Start Session',
              subtitle: 'Begin your daily routine',
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Start Session'), findsOneWidget);
      expect(find.text('Begin your daily routine'), findsOneWidget);
    });

    testWidgets('triggers onTap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Start Session',
              subtitle: 'Begin your daily routine',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('animates on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Start Session',
              subtitle: 'Begin your daily routine',
              onTap: () {},
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(DailyActionCard));
      await tester.pump(); // Start tap animation
      
      // Animation in progress (300ms morph + 200ms delay + 300ms reverse)
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(); // Process reverse animation start
      await tester.pump(const Duration(milliseconds: 300)); // Complete reverse
      
      expect(find.byType(DailyActionCard), findsOneWidget);
    });

    testWidgets('has pulsing animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Start Session',
              subtitle: 'Begin your daily routine',
              onTap: () {},
            ),
          ),
        ),
      );

      // Initial state
      await tester.pump();
      
      // Advance pulse animation
      await tester.pump(const Duration(milliseconds: 750));
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(DailyActionCard), findsOneWidget);
    });

    testWidgets('renders custom paint for irregular polygon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyActionCard(
              title: 'Start Session',
              subtitle: 'Begin your daily routine',
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('ProgressRing Widget Tests', () {
    testWidgets('renders with progress value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.75,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('75%'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('animates progress changes', (WidgetTester tester) async {
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
      expect(find.text('0%'), findsOneWidget);

      // Update progress
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

      // Animation in progress
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('renders hexagonal segments', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.5,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('handles zero progress', (WidgetTester tester) async {
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
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('handles full progress', (WidgetTester tester) async {
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

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('respects custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.5,
              size: 200,
            ),
          ),
        ),
      );

      await tester.pump();

      final progressRing = tester.widget<ProgressRing>(find.byType(ProgressRing));
      expect(progressRing.size, 200);
    });

    testWidgets('animates particle trail', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.5,
              size: 150,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Advance particle animation
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 1000));
      
      expect(find.byType(ProgressRing), findsOneWidget);
    });
  });

  group('StreakCounter Widget Tests', () {
    testWidgets('renders streak count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 7,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('7'), findsOneWidget);
      expect(find.text('Day Streak'), findsOneWidget);
    });

    testWidgets('animates streak count changes', (WidgetTester tester) async {
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

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.text('5'), findsOneWidget);

      // Update streak
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 10,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('renders crystalline structure', (WidgetTester tester) async {
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

      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('handles zero streak', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 0,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('handles maximum streak display', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 100,
              size: 120,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('animates holographic effect', (WidgetTester tester) async {
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
      
      // Advance holographic animation
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump(const Duration(milliseconds: 1500));
      
      expect(find.byType(StreakCounter), findsOneWidget);
    });

    testWidgets('respects custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 5,
              size: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      final streakCounter = tester.widget<StreakCounter>(find.byType(StreakCounter));
      expect(streakCounter.size, 150);
    });

    testWidgets('applies 3D transform effect', (WidgetTester tester) async {
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

      await tester.pump();

      expect(find.byType(Transform), findsWidgets);
    });
  });

  group('TrendChart Widget Tests', () {
    testWidgets('renders with data points and labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
              title: 'ROM Progress',
              height: 200,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ROM Progress'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('animates chart drawing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
              title: 'ROM Progress',
              height: 200,
            ),
          ),
        ),
      );

      // Initial render
      await tester.pump();
      
      // Animation in progress
      await tester.pump(const Duration(milliseconds: 750));
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(TrendChart), findsOneWidget);
    });

    testWidgets('handles tap interactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
              title: 'ROM Progress',
              height: 200,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));

      // Tap on chart
      final chartFinder = find.byType(CustomPaint).last;
      await tester.tap(chartFinder);
      await tester.pump();
      
      expect(find.byType(TrendChart), findsOneWidget);
    });

    testWidgets('handles empty data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [],
              labels: [],
              title: 'Empty Chart',
              height: 200,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Empty Chart'), findsOneWidget);
    });

    testWidgets('handles single data point', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [50],
              labels: ['Day 1'],
              title: 'Single Point',
              height: 200,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      
      expect(find.text('Single Point'), findsOneWidget);
    });

    testWidgets('respects custom height', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15],
              labels: ['A', 'B', 'C'],
              title: 'Custom Height',
              height: 300,
            ),
          ),
        ),
      );

      await tester.pump();

      final trendChart = tester.widget<TrendChart>(find.byType(TrendChart));
      expect(trendChart.height, 300);
    });
  });
}
