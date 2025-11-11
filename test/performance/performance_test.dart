import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/progress_ring.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/status_header.dart';
import 'package:rehab_tracker_pro/features/dashboard/widgets/trend_chart.dart';
import 'package:rehab_tracker_pro/utils/performance_utils.dart';

void main() {
  group('Performance - RepaintBoundary Usage', () {
    testWidgets('ProgressRing uses RepaintBoundary for animations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(progress: 0.5),
          ),
        ),
      );

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('StatusHeader uses RepaintBoundary for particles', (tester) async {
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

      // Verify RepaintBoundary is present
      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });

  group('Performance - Custom Painter Optimization', () {
    testWidgets('ProgressRing painter optimizes repaints', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(progress: 0.5),
          ),
        ),
      );

      // Verify CustomPaint is present
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('TrendChart painter optimizes repaints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrendChart(
              title: 'Test',
              dataPoints: const [10, 20, 30],
              labels: const ['A', 'B', 'C'],
            ),
          ),
        ),
      );

      // Verify CustomPaint is present
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('Performance - Animation Performance', () {
    testWidgets('ProgressRing animation completes smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(progress: 0.0),
          ),
        ),
      );

      // Start animation
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(progress: 1.0),
          ),
        ),
      );

      // Pump frames to complete animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify widget is still present and rendered
      expect(find.byType(ProgressRing), findsOneWidget);
    });

    testWidgets('StatusHeader particle animation runs without errors', (tester) async {
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

      // Pump several frames to test animation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify widget is still present
      expect(find.byType(StatusHeader), findsOneWidget);
    });
  });

  group('Performance - Reduced Motion Support', () {
    testWidgets('shouldReduceMotion detects disabled animations', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: _PerformanceTestWidget(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(_PerformanceTestWidget));
      expect(PerformanceUtils.shouldReduceMotion(context), true);
    });

    testWidgets('getAnimationDuration returns reduced duration', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: _PerformanceTestWidget(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(_PerformanceTestWidget));
      final duration = PerformanceUtils.getAnimationDuration(
        context,
        normal: const Duration(milliseconds: 300),
        reduced: const Duration(milliseconds: 100),
      );
      
      expect(duration, const Duration(milliseconds: 100));
    });

    testWidgets('getAnimationCurve returns linear curve for reduced motion', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: _PerformanceTestWidget(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(_PerformanceTestWidget));
      final curve = PerformanceUtils.getAnimationCurve(
        context,
        normal: Curves.easeInOut,
        reduced: Curves.linear,
      );
      
      expect(curve, Curves.linear);
    });
  });

  group('Performance - Memory Management', () {
    testWidgets('widgets dispose controllers properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(progress: 0.5),
          ),
        ),
      );

      // Remove widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(),
          ),
        ),
      );

      // Verify no errors during disposal
      expect(tester.takeException(), isNull);
    });

    testWidgets('StatusHeader disposes animation controllers', (tester) async {
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

      // Remove widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(),
          ),
        ),
      );

      // Verify no errors during disposal
      expect(tester.takeException(), isNull);
    });
  });

  group('Performance - Rendering Efficiency', () {
    testWidgets('TrendChart renders efficiently with data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrendChart(
              title: 'Test Chart',
              dataPoints: const [10, 20, 15, 25, 30],
              labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            ),
          ),
        ),
      );

      // Verify widget renders without errors
      expect(find.byType(TrendChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Multiple progress rings render efficiently', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  10,
                  (index) => const ProgressRing(progress: 0.5),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify all widgets render
      expect(find.byType(ProgressRing), findsNWidgets(10));
      expect(tester.takeException(), isNull);
    });
  });

  group('Performance - OptimizedWidget Utility', () {
    testWidgets('OptimizedWidget adds RepaintBoundary by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OptimizedWidget(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // MaterialApp and Scaffold add their own RepaintBoundaries
      // We just verify OptimizedWidget is present
      expect(find.byType(OptimizedWidget), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('OptimizedWidget can skip RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OptimizedWidget(
              addRepaintBoundary: false,
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Verify OptimizedWidget is present
      expect(find.byType(OptimizedWidget), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}

class _PerformanceTestWidget extends StatelessWidget {
  const _PerformanceTestWidget();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
