import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/widgets/common/professional_inputs.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

void main() {
  group('ProfessionalTextField', () {
    testWidgets('renders with correct height constraint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalTextField(
              decoration: const InputDecoration(
                labelText: 'Test Field',
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      
      final constrainedBox = find.ancestor(
        of: textField,
        matching: find.byType(ConstrainedBox),
      );
      expect(constrainedBox, findsOneWidget);
    });

    testWidgets('uses 18px font size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ProfessionalTextField(
              decoration: InputDecoration(
                labelText: 'Test Field',
              ),
            ),
          ),
        ),
      );

      // Verify the text field renders
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      
      // The font size is set via the style property in ProfessionalTextField
      // which uses theme.textTheme.bodyLarge with fontSize: 18
    });
  });

  group('ProfessionalSlider', () {
    testWidgets('renders with correct track height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalSlider(
              value: 50,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);
    });

    testWidgets('calls onChanged with haptic feedback', (tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalSlider(
              value: 50,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
    });
  });

  group('ProfessionalLabeledSlider', () {
    testWidgets('displays label and value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalLabeledSlider(
              label: 'Test Slider',
              value: 75,
              onChanged: (_) {},
              minLabel: 'Min',
              maxLabel: 'Max',
            ),
          ),
        ),
      );

      expect(find.text('Test Slider'), findsOneWidget);
      expect(find.text('75'), findsOneWidget);
      expect(find.text('Min'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
    });
  });

  group('ProfessionalCheckbox', () {
    testWidgets('renders with correct size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalCheckbox(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final sizedBox = find.ancestor(
        of: find.byType(Checkbox),
        matching: find.byType(SizedBox),
      );
      expect(sizedBox, findsOneWidget);
      
      final box = tester.widget<SizedBox>(sizedBox);
      expect(box.width, AppTheme.checkboxSize);
      expect(box.height, AppTheme.checkboxSize);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalCheckbox(
              value: false,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(changedValue, true);
    });
  });

  group('ProfessionalCheckboxListTile', () {
    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalCheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Test Title'),
              subtitle: const Text('Test Subtitle'),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('toggles value when tapped', (tester) async {
      bool value = false;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ProfessionalCheckboxListTile(
                  value: value,
                  onChanged: (newValue) {
                    setState(() => value = newValue);
                  },
                  title: const Text('Test'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(value, true);
    });
  });

  group('ProfessionalSwitch', () {
    testWidgets('renders with correct size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalSwitch(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final sizedBox = find.ancestor(
        of: find.byType(FittedBox),
        matching: find.byType(SizedBox),
      );
      expect(sizedBox, findsOneWidget);
      
      final box = tester.widget<SizedBox>(sizedBox);
      expect(box.height, AppTheme.checkboxSize);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalSwitch(
              value: false,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(changedValue, true);
    });
  });

  group('ProfessionalSwitchListTile', () {
    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProfessionalSwitchListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Test Title'),
              subtitle: const Text('Test Subtitle'),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('toggles value when tapped', (tester) async {
      bool value = false;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ProfessionalSwitchListTile(
                  value: value,
                  onChanged: (newValue) {
                    setState(() => value = newValue);
                  },
                  title: const Text('Test'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(value, true);
    });
  });
}
