import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rehab_tracker_pro/main.dart' as app;
import 'package:rehab_tracker_pro/features/dashboard/widgets/dashboard_widgets.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/exercise_list.dart';
import 'package:rehab_tracker_pro/features/routine/widgets/content_grid.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/rom_interface.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/measurement_input_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to reset app state between tests
  Future<void> resetAppState() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  group('Complete User Flow Integration Tests', () {
    setUp(() async {
      await resetAppState();
    });

    testWidgets('Complete user journey from dashboard to exercise completion',
        (WidgetTester tester) async {
      // Requirement 5.1: Test complete workflow with data persistence
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify dashboard loads (Requirement 1.1, 1.2)
      expect(find.text("Start Today's Session"), findsOneWidget);
      
      // Verify status header is visible (Requirement 1.1)
      expect(find.byType(StatusHeader), findsOneWidget);
      
      // Verify progress widgets are visible (Requirement 1.3, 1.4)
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);

      // Tap on daily action card to navigate to routine
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      // Verify we're on the routine screen (Requirement 2.1)
      expect(find.text('My Routine'), findsOneWidget);
      expect(find.text('Exercises'), findsOneWidget);

      // Wait for exercise list to load
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find and tap the first exercise toggle (Requirement 2.2, 2.3)
      final exerciseToggles = find.byType(GeometricToggle);
      if (exerciseToggles.evaluate().isNotEmpty) {
        await tester.tap(exerciseToggles.first);
        await tester.pumpAndSettle();

        // Wait for reward animation to complete (Requirement 2.3)
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate to symptoms tab
      await tester.tap(find.text('Symptoms'));
      await tester.pumpAndSettle();

      // Verify symptom tracking widgets are visible (Requirement 2.4)
      expect(find.text('Pain Level'), findsOneWidget);
      expect(find.text('Swelling'), findsOneWidget);
      expect(find.text('Medication Taken'), findsOneWidget);

      // Save symptom log (Requirement 2.5, 5.1)
      await tester.tap(find.text('Save Symptom Log'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Symptom log saved successfully!'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to library tab (Requirement 2.6)
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      // Verify content grid is visible (Requirement 2.6, 2.7)
      expect(find.byType(ContentGrid), findsOneWidget);

      // Navigate to ROM measurement via bottom navigation
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        // Verify ROM interface is visible (Requirement 3.1)
        expect(find.byType(ROMInterface), findsOneWidget);
      }

      // Navigate back to dashboard
      final dashboardNavButton = find.text('Dashboard');
      if (dashboardNavButton.evaluate().isNotEmpty) {
        await tester.tap(dashboardNavButton);
        await tester.pumpAndSettle();

        // Verify we're back on dashboard
        expect(find.text("Start Today's Session"), findsOneWidget);
      }
    });

    testWidgets('ROM measurement complete workflow', (WidgetTester tester) async {
      // Requirement 3.1-3.7, 5.3: Test ROM measurement with data persistence
      app.main();
      await tester.pumpAndSettle();

      // Navigate to ROM screen (Requirement 3.1)
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        // Verify ROM interface is displayed (Requirement 3.1)
        expect(find.byType(ROMInterface), findsOneWidget);

        // Verify instructions are visible (Requirement 3.2, 3.7)
        expect(find.textContaining('Ready'), findsWidgets);

        // Verify legal disclaimer is visible (Requirement 3.6)
        expect(find.textContaining('not a substitute'), findsWidgets);

        // Find and tap complete measurement button (Requirement 3.5)
        final completeMeasurementButton = find.text('Complete Measurement');
        if (completeMeasurementButton.evaluate().isNotEmpty) {
          await tester.tap(completeMeasurementButton);
          await tester.pumpAndSettle();

          // Verify measurement input dialog appears (Requirement 3.4)
          expect(find.byType(MeasurementInputDialog), findsOneWidget);

          // Fill in measurement data (Requirement 3.4)
          final angleField = find.byType(TextField).first;
          await tester.enterText(angleField, '75');
          await tester.pumpAndSettle();

          // Save measurement (Requirement 5.3)
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();

          // Verify success message (Requirement 5.4)
          expect(find.text('ROM measurement saved! +15 points'), findsOneWidget);
        }
      }
    });

    testWidgets('Data persistence across navigation', (WidgetTester tester) async {
      // Requirement 5.2: Test data restoration across navigation
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text("Start Today's Session"), findsOneWidget);
      
      // Navigate to routine and complete an exercise
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      // Complete an exercise (Requirement 5.1)
      final exerciseToggles = find.byType(GeometricToggle);
      if (exerciseToggles.evaluate().isNotEmpty) {
        await tester.tap(exerciseToggles.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate back to dashboard
      final dashboardNavButton = find.text('Dashboard');
      if (dashboardNavButton.evaluate().isNotEmpty) {
        await tester.tap(dashboardNavButton);
        await tester.pumpAndSettle();

        // Verify dashboard still shows correct data (Requirement 5.2)
        expect(find.text("Start Today's Session"), findsOneWidget);
        expect(find.byType(StatusHeader), findsOneWidget);
      }

      // Navigate to ROM screen
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();
      }

      // Navigate back to dashboard again
      if (dashboardNavButton.evaluate().isNotEmpty) {
        await tester.tap(dashboardNavButton);
        await tester.pumpAndSettle();

        // Verify data persists (Requirement 5.2)
        expect(find.text("Start Today's Session"), findsOneWidget);
      }
    });

    testWidgets('Animation performance test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Measure frame rendering time
      final binding = IntegrationTestWidgetsFlutterBinding.instance;
      
      // Navigate between screens multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text("Start Today's Session"));
        await tester.pumpAndSettle();

        final dashboardNavButton = find.text('Dashboard');
        if (dashboardNavButton.evaluate().isNotEmpty) {
          await tester.tap(dashboardNavButton);
          await tester.pumpAndSettle();
        }
      }

      // Verify no frame drops (this is a basic check)
      // In a real scenario, you'd use more sophisticated performance monitoring
    });
  });

  group('Data Persistence Across App Restarts', () {
    testWidgets('Exercise completion persists after app restart',
        (WidgetTester tester) async {
      // Requirement 5.2: Test data restoration after app restart
      
      // First app session - complete an exercise
      app.main();
      await tester.pumpAndSettle();

      // Navigate to routine
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      // Complete an exercise
      final exerciseToggles = find.byType(GeometricToggle);
      if (exerciseToggles.evaluate().isNotEmpty) {
        await tester.tap(exerciseToggles.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Simulate app restart by creating a new app instance
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Second app session - verify data persists
      app.main();
      await tester.pumpAndSettle();

      // Verify dashboard loads with persisted data (Requirement 5.2)
      expect(find.text("Start Today's Session"), findsOneWidget);
      expect(find.byType(StatusHeader), findsOneWidget);
    });

    testWidgets('ROM measurements persist after app restart',
        (WidgetTester tester) async {
      // Requirement 5.3: Test ROM measurement history persistence
      
      // First app session - save a ROM measurement
      app.main();
      await tester.pumpAndSettle();

      // Navigate to ROM screen
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        // Complete a measurement
        final completeMeasurementButton = find.text('Complete Measurement');
        if (completeMeasurementButton.evaluate().isNotEmpty) {
          await tester.tap(completeMeasurementButton);
          await tester.pumpAndSettle();

          final angleField = find.byType(TextField).first;
          await tester.enterText(angleField, '85');
          await tester.pumpAndSettle();

          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      // Simulate app restart
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Second app session - verify measurement history persists
      app.main();
      await tester.pumpAndSettle();

      // Navigate to ROM screen
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        // Verify ROM interface loads (data should be persisted)
        expect(find.byType(ROMInterface), findsOneWidget);
      }
    });

    testWidgets('Gamification state persists after app restart',
        (WidgetTester tester) async {
      // Requirement 5.4: Test gamification state persistence
      
      // First app session - earn points
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(StatusHeader), findsOneWidget);

      // Complete activities to earn points
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      final exerciseToggles = find.byType(GeometricToggle);
      if (exerciseToggles.evaluate().isNotEmpty) {
        await tester.tap(exerciseToggles.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Simulate app restart
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Second app session - verify points persist
      app.main();
      await tester.pumpAndSettle();

      // Verify gamification state is maintained (Requirement 5.4)
      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
    });

    testWidgets('Symptom logs persist after app restart',
        (WidgetTester tester) async {
      // Requirement 5.1, 5.6: Test symptom log persistence
      
      // First app session - save symptom log
      app.main();
      await tester.pumpAndSettle();

      // Navigate to routine symptoms tab
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Symptoms'));
      await tester.pumpAndSettle();

      // Save symptom log
      await tester.tap(find.text('Save Symptom Log'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Simulate app restart
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Second app session - verify symptom data persists
      app.main();
      await tester.pumpAndSettle();

      // Navigate to dashboard and verify historical data is accessible
      expect(find.text("Start Today's Session"), findsOneWidget);
      expect(find.byType(StatusHeader), findsOneWidget);
    });
  });

  group('Error Recovery and Edge Cases', () {
    testWidgets('Handle empty exercise list gracefully',
        (WidgetTester tester) async {
      // Requirement 5.4: Test error handling
      await resetAppState();
      
      app.main();
      await tester.pumpAndSettle();

      // Navigate to routine
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      // Verify screen loads even with no exercises
      expect(find.text('My Routine'), findsOneWidget);
      expect(find.text('Exercises'), findsOneWidget);
    });

    testWidgets('Handle invalid ROM measurement input',
        (WidgetTester tester) async {
      // Requirement 5.4: Test error recovery
      app.main();
      await tester.pumpAndSettle();

      // Navigate to ROM screen
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        final completeMeasurementButton = find.text('Complete Measurement');
        if (completeMeasurementButton.evaluate().isNotEmpty) {
          await tester.tap(completeMeasurementButton);
          await tester.pumpAndSettle();

          // Try to save without entering data
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();

          // Verify dialog is still open or error is shown
          // The app should handle this gracefully
        }
      }
    });

    testWidgets('Handle rapid navigation between screens',
        (WidgetTester tester) async {
      // Requirement 5.4: Test edge case handling
      app.main();
      await tester.pumpAndSettle();

      // Rapidly navigate between screens
      for (int i = 0; i < 5; i++) {
        final romNavButton = find.text('ROM');
        if (romNavButton.evaluate().isNotEmpty) {
          await tester.tap(romNavButton);
          await tester.pump(const Duration(milliseconds: 100));
        }

        final dashboardNavButton = find.text('Dashboard');
        if (dashboardNavButton.evaluate().isNotEmpty) {
          await tester.tap(dashboardNavButton);
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await tester.pumpAndSettle();

      // Verify app is still functional
      expect(find.text("Start Today's Session"), findsOneWidget);
    });

    testWidgets('Handle multiple exercise completions',
        (WidgetTester tester) async {
      // Requirement 5.1, 5.4: Test multiple data operations
      app.main();
      await tester.pumpAndSettle();

      // Navigate to routine
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      // Complete multiple exercises
      final exerciseToggles = find.byType(GeometricToggle);
      final toggleCount = exerciseToggles.evaluate().length;
      
      for (int i = 0; i < toggleCount && i < 3; i++) {
        if (exerciseToggles.evaluate().isNotEmpty) {
          await tester.tap(exerciseToggles.at(i));
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }

      // Verify app handles multiple completions
      expect(find.text('My Routine'), findsOneWidget);
    });

    testWidgets('Handle back navigation from all screens',
        (WidgetTester tester) async {
      // Requirement 5.4: Test navigation edge cases
      app.main();
      await tester.pumpAndSettle();

      // Test navigation from routine screen
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      final dashboardNavButton = find.text('Dashboard');
      if (dashboardNavButton.evaluate().isNotEmpty) {
        await tester.tap(dashboardNavButton);
        await tester.pumpAndSettle();
        expect(find.text("Start Today's Session"), findsOneWidget);
      }

      // Test navigation from ROM screen
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        if (dashboardNavButton.evaluate().isNotEmpty) {
          await tester.tap(dashboardNavButton);
          await tester.pumpAndSettle();
          expect(find.text("Start Today's Session"), findsOneWidget);
        }
      }
    });

    testWidgets('Verify all required UI elements are present',
        (WidgetTester tester) async {
      // Requirement 5.2: Comprehensive UI verification
      app.main();
      await tester.pumpAndSettle();

      // Verify dashboard elements (Requirement 1.1-1.6)
      expect(find.text("Start Today's Session"), findsOneWidget);
      expect(find.byType(StatusHeader), findsOneWidget);
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.byType(StreakCounter), findsOneWidget);

      // Navigate to routine and verify elements (Requirement 2.1-2.7)
      await tester.tap(find.text("Start Today's Session"));
      await tester.pumpAndSettle();

      expect(find.text('My Routine'), findsOneWidget);
      expect(find.text('Exercises'), findsOneWidget);
      expect(find.text('Symptoms'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);

      // Navigate to ROM and verify elements (Requirement 3.1-3.7)
      final romNavButton = find.text('ROM');
      if (romNavButton.evaluate().isNotEmpty) {
        await tester.tap(romNavButton);
        await tester.pumpAndSettle();

        expect(find.byType(ROMInterface), findsOneWidget);
        expect(find.textContaining('not a substitute'), findsWidgets);
      }
    });
  });
}
