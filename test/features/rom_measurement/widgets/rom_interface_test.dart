import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/rom_interface.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/instruction_display.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/angle_gauge.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/geometric_action_button.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/widgets/measurement_input_dialog.dart';
import 'package:rehab_tracker_pro/features/rom_measurement/rom_screen.dart';
import 'package:rehab_tracker_pro/models/rom_measurement.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void setUpMobileScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
  }

  group('ROMInterface Widget Tests', () {
    testWidgets('renders initial idle state correctly', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ROM Measurement'), findsOneWidget);
      expect(find.text('Start Measurement'), findsOneWidget);
      expect(find.byType(InstructionDisplay), findsOneWidget);
      expect(find.byType(AngleGauge), findsOneWidget);
      expect(find.text('For informational purposes only. Not a medical diagnostic tool.'), findsOneWidget);
    });

    testWidgets('displays back button', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows legal disclaimer persistently', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text('For informational purposes only. Not a medical diagnostic tool.'), findsOneWidget);
    });
  });

  group('Measurement Flow Tests', () {
    testWidgets('displays instruction display for guidance', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.byType(InstructionDisplay), findsOneWidget);
      expect(find.text('Ready to Measure'), findsOneWidget);
      expect(find.text('Position yourself and tap Start Measurement'), findsOneWidget);
    });

    testWidgets('displays angle gauge for measurement visualization', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(AngleGauge), findsOneWidget);
    });

    testWidgets('displays action button with correct initial state', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.byType(GeometricActionButton), findsOneWidget);
      expect(find.text('Start Measurement'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  });

  group('InstructionDisplay Tests', () {
    testWidgets('displays correct instruction for idle state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InstructionDisplay(state: MeasurementState.idle),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Ready to Measure'), findsOneWidget);
      expect(find.text('Position yourself and tap Start Measurement'), findsOneWidget);
    });

    testWidgets('renders geometric indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InstructionDisplay(state: MeasurementState.idle),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('Data Storage Tests', () {
    testWidgets('ROMScreen integrates with provider', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ROMScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('ROM Measurement'), findsOneWidget);
      expect(find.byType(ROMInterface), findsOneWidget);
    });

    testWidgets('measurement input dialog displays all required fields', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MeasurementInputDialog(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Save Measurement'), findsOneWidget);
      expect(find.text('Joint Type'), findsOneWidget);
      expect(find.text('Maximum Angle'), findsOneWidget);
      expect(find.text('Session Notes (Optional)'), findsOneWidget);
      
      expect(find.text('Knee'), findsOneWidget);
      expect(find.text('Elbow'), findsOneWidget);
      expect(find.text('Shoulder'), findsOneWidget);
      expect(find.text('Hip'), findsOneWidget);
      expect(find.text('Ankle'), findsOneWidget);
      expect(find.text('Wrist'), findsOneWidget);
    });
  });

  group('User Guidance Tests', () {
    testWidgets('provides clear visual hierarchy', (WidgetTester tester) async {
      setUpMobileScreen(tester);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ROMInterface(
              measurements: const [],
              onStartMeasurement: () {},
              onCompleteMeasurement: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('ROM Measurement'), findsOneWidget);
      expect(find.byType(InstructionDisplay), findsOneWidget);
      expect(find.byType(AngleGauge), findsOneWidget);
      expect(find.byType(GeometricActionButton), findsOneWidget);
    });
  });
}
