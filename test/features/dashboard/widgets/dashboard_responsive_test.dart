import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/status_header.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/daily_action_card.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/progress_ring.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/streak_counter.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/trend_chart.dart';

void main() {
  group('Dashboard Responsive Behavior - Small Screens', () {
    testWidgets('StatusHeader renders on small screen (iPhone SE)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

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

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
      expect(find.text('LV 3'), findsOneWidget);
    });

    testWidgets('DailyActionCard fits on small screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: DailyActionCard(
                title: 'Start Session',
                subtitle: 'Begin your daily routine',
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Session'), findsOneWidget);
      expect(find.text('Begin your daily routine'), findsOneWidget);
      
      // Verify card doesn't overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProgressRing scales appropriately on small screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 0.75,
                size: 120, // Smaller size for small screen
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
    });

    testWidgets('StreakCounter renders on small screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: StreakCounter(
                streakCount: 7,
                size: 100, // Smaller size for small screen
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('DAY STREAK'), findsOneWidget);
    });

    testWidgets('TrendChart adapts to small screen width', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25],
              labels: ['M', 'T', 'W', 'T', 'F'], // Shorter labels
              title: 'Progress',
              height: 180,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Dashboard Responsive Behavior - Medium Screens', () {
    testWidgets('StatusHeader renders on medium screen (iPhone 12)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

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

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
      expect(find.text('LV 5'), findsOneWidget);
    });

    testWidgets('DailyActionCard has proper spacing on medium screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: DailyActionCard(
                title: 'Start Today\'s Session',
                subtitle: 'Complete your exercises',
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Today\'s Session'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProgressRing uses standard size on medium screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 0.65,
                size: 150,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('65%'), findsOneWidget);
    });

    testWidgets('Multiple widgets layout correctly on medium screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const StatusHeader(
                    recoveryPoints: 200,
                    currentLevel: 4,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DailyActionCard(
                      title: 'Start Session',
                      subtitle: 'Begin now',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProgressRing(progress: 0.8, size: 140),
                      StreakCounter(streakCount: 5, size: 110),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);
    });
  });

  group('Dashboard Responsive Behavior - Large Screens', () {
    testWidgets('StatusHeader renders on large screen (iPhone Pro Max)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusHeader(
              recoveryPoints: 500,
              currentLevel: 10,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.text('LV 10'), findsOneWidget);
    });

    testWidgets('DailyActionCard has generous spacing on large screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: DailyActionCard(
                title: 'Start Today\'s Session',
                subtitle: 'Complete your rehabilitation exercises',
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Today\'s Session'), findsOneWidget);
      expect(find.text('Complete your rehabilitation exercises'), findsOneWidget);
    });

    testWidgets('ProgressRing uses larger size on large screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 0.85,
                size: 180,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('85%'), findsOneWidget);
    });

    testWidgets('TrendChart has more space on large screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrendChart(
              dataPoints: [10, 20, 15, 30, 25, 35, 28, 40],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Mon'],
              title: 'Weekly ROM Progress',
              height: 250,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Weekly ROM Progress'), findsOneWidget);
    });

    testWidgets('Full dashboard layout on large screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const StatusHeader(
                    recoveryPoints: 350,
                    currentLevel: 7,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DailyActionCard(
                      title: 'Start Today\'s Session',
                      subtitle: 'Complete your exercises',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProgressRing(progress: 0.7, size: 160),
                      StreakCounter(streakCount: 12, size: 130),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const TrendChart(
                    dataPoints: [15, 25, 20, 35, 30, 40, 38],
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    title: 'Weekly Progress',
                    height: 240,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);
      expect(find.byType(TrendChart), findsOneWidget);
    });
  });

  group('Dashboard Responsive Behavior - Tablet Screens', () {
    testWidgets('Dashboard widgets scale on tablet (iPad)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const StatusHeader(
                    recoveryPoints: 400,
                    currentLevel: 8,
                  ),
                  const SizedBox(height: 32),
                  DailyActionCard(
                    title: 'Start Session',
                    subtitle: 'Begin your exercises',
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProgressRing(progress: 0.9, size: 200),
                      StreakCounter(streakCount: 15, size: 160),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);
    });
  });

  group('Dashboard Responsive Behavior - Orientation Changes', () {
    testWidgets('Widgets adapt to landscape orientation', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(844, 390); // Landscape
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                const Expanded(
                  child: StatusHeader(
                    recoveryPoints: 200,
                    currentLevel: 4,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ProgressRing(progress: 0.6, size: 120),
                      const SizedBox(height: 16),
                      DailyActionCard(
                        title: 'Start',
                        subtitle: 'Begin',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
    });

    testWidgets('TrendChart adapts to landscape', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(844, 390); // Landscape
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: TrendChart(
                dataPoints: [10, 20, 15, 30, 25, 35, 28, 40, 38, 45],
                labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
                title: 'Progress',
                height: 200,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Dashboard Responsive Behavior - Edge Cases', () {
    testWidgets('Handles very small screen gracefully', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(240, 320);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  StatusHeader(
                    recoveryPoints: 50,
                    currentLevel: 1,
                  ),
                  SizedBox(height: 8),
                  ProgressRing(progress: 0.5, size: 80),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Handles very large screen gracefully', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const StatusHeader(
                      recoveryPoints: 1000,
                      currentLevel: 20,
                    ),
                    const SizedBox(height: 40),
                    DailyActionCard(
                      title: 'Start Session',
                      subtitle: 'Begin exercises',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(DailyActionCard), findsOneWidget);
    });
  });
}
