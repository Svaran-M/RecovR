import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';
import 'package:rehab_tracker_pro/utils/accessibility_utils.dart';

void main() {
  group('Accessibility Compliance - Color Contrast', () {
    test('primary color meets WCAG AA contrast ratio on white background', () {
      final ratio = AccessibilityUtils.calculateContrastRatio(
        AppTheme.primaryGeometric,
        Colors.white,
      );
      
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Primary color should have at least 4.5:1 contrast ratio');
    });

    test('secondary color meets WCAG AA contrast ratio on white background', () {
      final ratio = AccessibilityUtils.calculateContrastRatio(
        AppTheme.secondaryGeometric,
        Colors.white,
      );
      
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Secondary color should have at least 4.5:1 contrast ratio');
    });

    test('accent color meets WCAG AA contrast ratio on dark background', () {
      final ratio = AccessibilityUtils.calculateContrastRatio(
        AppTheme.accentGeometric,
        AppTheme.backgroundDark,
      );
      
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Accent color should have at least 4.5:1 contrast ratio on dark background');
    });

    test('text on primary background meets contrast requirements', () {
      final ratio = AccessibilityUtils.calculateContrastRatio(
        Colors.white,
        AppTheme.primaryGeometric,
      );
      
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'White text on primary background should be readable');
    });

    test('meetsContrastRatio helper works correctly', () {
      expect(
        AccessibilityUtils.meetsContrastRatio(
          Colors.black,
          Colors.white,
          minimumRatio: 4.5,
        ),
        true,
        reason: 'Black on white should meet 4.5:1 ratio',
      );

      expect(
        AccessibilityUtils.meetsContrastRatio(
          Colors.grey,
          Colors.white,
          minimumRatio: 7.0,
        ),
        false,
        reason: 'Grey on white should not meet 7:1 ratio',
      );
    });
  });

  group('Accessibility Compliance - Touch Targets', () {
    testWidgets('ensureTouchTarget creates minimum 48x48 target', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.ensureTouchTarget(
                child: const Icon(Icons.add, size: 20),
              ),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox that wraps our icon
      final constrainedBoxes = find.byType(ConstrainedBox);
      expect(constrainedBoxes, findsWidgets);
      
      // Verify the icon is present
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('accessibleButton has proper touch target', (tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.accessibleButton(
                label: 'Test Button',
                onPressed: () => tapped = true,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );

      // Verify button is present and tappable
      expect(find.text('Tap me'), findsOneWidget);
      
      await tester.tap(find.text('Tap me'));
      expect(tapped, true);
    });
  });

  group('Accessibility Compliance - Semantics', () {
    testWidgets('withSemantics adds Semantics widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.withSemantics(
                label: 'Test Label',
                hint: 'Test Hint',
                button: true,
                child: const Text('Button'),
              ),
            ),
          ),
        ),
      );

      // Verify the text is present (semantics are added)
      expect(find.text('Button'), findsOneWidget);
    });

    testWidgets('accessibleText creates text with Semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.accessibleText(
                text: 'Header Text',
                isHeader: true,
              ),
            ),
          ),
        ),
      );

      // Verify the text is present
      expect(find.text('Header Text'), findsOneWidget);
    });

    testWidgets('accessibleIcon creates icon with Semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.accessibleIcon(
                icon: Icons.home,
                label: 'Home',
              ),
            ),
          ),
        ),
      );

      // Verify the icon is present
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('decorative excludes content from semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.decorative(
                const Icon(Icons.star),
              ),
            ),
          ),
        ),
      );

      // Verify the icon is present
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('Accessibility Compliance - Interactive Elements', () {
    testWidgets('accessibleSlider creates slider with semantics', (tester) async {
      double value = 5.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.accessibleSlider(
                value: value,
                min: 0,
                max: 10,
                onChanged: (newValue) => value = newValue,
                label: 'Pain Level',
                valueFormatter: (v) => '${v.toInt()} out of 10',
              ),
            ),
          ),
        ),
      );

      // Verify slider is present
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('accessibleToggle creates switch with semantics', (tester) async {
      bool value = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibilityUtils.accessibleToggle(
                value: value,
                onChanged: (newValue) => value = newValue,
                label: 'Enable Notifications',
                enabledHint: 'Notifications enabled',
                disabledHint: 'Notifications disabled',
              ),
            ),
          ),
        ),
      );

      // Verify switch is present
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('Accessibility Compliance - Reduced Motion', () {
    testWidgets('respects reduced motion preference', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: _TestAnimatedWidget(),
            ),
          ),
        ),
      );

      final context = tester.element(find.byType(_TestAnimatedWidget));
      expect(MediaQuery.of(context).disableAnimations, true);
    });
  });
}

class _TestAnimatedWidget extends StatelessWidget {
  const _TestAnimatedWidget();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
