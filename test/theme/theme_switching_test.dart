import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';
import 'package:rehab_tracker_pro/utils/theme_tester.dart';

void main() {
  group('Theme Switching Tests', () {
    test('Light theme has correct brightness', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
      expect(AppTheme.lightColorScheme.brightness, Brightness.light);
    });

    test('Dark theme has correct brightness', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
      expect(AppTheme.darkColorScheme.brightness, Brightness.dark);
    });

    test('Light theme primary color is professional blue', () {
      expect(AppTheme.lightColorScheme.primary, const Color(0xFF0061A4));
    });

    test('Dark theme primary color is light blue', () {
      expect(AppTheme.darkColorScheme.primary, const Color(0xFF9ECAFF));
    });

    test('Light theme surface is light', () {
      expect(AppTheme.lightColorScheme.surface.computeLuminance() > 0.5, true);
    });

    test('Dark theme surface is dark', () {
      expect(AppTheme.darkColorScheme.surface.computeLuminance() < 0.5, true);
    });
  });

  group('Contrast Ratio Tests - Light Theme', () {
    final scheme = AppTheme.lightColorScheme;

    test('Primary on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.primary,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnSurface on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onSurface,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnPrimary on Primary meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onPrimary,
        scheme.primary,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('Error on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.error,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnPrimaryContainer on PrimaryContainer meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onPrimaryContainer,
        scheme.primaryContainer,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });
  });

  group('Contrast Ratio Tests - Dark Theme', () {
    final scheme = AppTheme.darkColorScheme;

    test('Primary on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.primary,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnSurface on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onSurface,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnPrimary on Primary meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onPrimary,
        scheme.primary,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('Error on Surface meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.error,
        scheme.surface,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });

    test('OnPrimaryContainer on PrimaryContainer meets WCAG AA', () {
      final ratio = ThemeTester.calculateContrastRatio(
        scheme.onPrimaryContainer,
        scheme.primaryContainer,
      );
      expect(ratio >= 4.5, true, reason: 'Ratio: $ratio');
    });
  });

  group('Theme Consistency Tests', () {
    test('Both themes use same spacing constants', () {
      expect(AppTheme.spacing8, 8.0);
      expect(AppTheme.spacing16, 16.0);
      expect(AppTheme.spacing24, 24.0);
      expect(AppTheme.spacing32, 32.0);
    });

    test('Both themes use same touch target sizes', () {
      expect(AppTheme.touchTargetMinimum, 48.0);
      expect(AppTheme.touchTargetPreferred, 56.0);
      expect(AppTheme.buttonHeightStandard, 64.0);
    });

    test('Both themes use same border radius values', () {
      expect(AppTheme.radiusSmall, 8.0);
      expect(AppTheme.radiusMedium, 12.0);
      expect(AppTheme.radiusLarge, 16.0);
    });

    test('Light and dark themes have matching text theme structure', () {
      final lightTextTheme = AppTheme.lightTheme.textTheme;
      final darkTextTheme = AppTheme.darkTheme.textTheme;

      // Check that font sizes match
      expect(
        lightTextTheme.bodyLarge?.fontSize,
        darkTextTheme.bodyLarge?.fontSize,
      );
      expect(
        lightTextTheme.headlineMedium?.fontSize,
        darkTextTheme.headlineMedium?.fontSize,
      );
      expect(
        lightTextTheme.titleLarge?.fontSize,
        darkTextTheme.titleLarge?.fontSize,
      );
    });
  });

  group('Semantic Color Tests', () {
    test('Success colors are defined', () {
      expect(AppTheme.successLight, isNotNull);
      expect(AppTheme.successDark, isNotNull);
    });

    test('Warning colors are defined', () {
      expect(AppTheme.warningLight, isNotNull);
      expect(AppTheme.warningDark, isNotNull);
    });

    test('Success light is darker than success dark', () {
      expect(
        AppTheme.successLight.computeLuminance() <
            AppTheme.successDark.computeLuminance(),
        true,
      );
    });

    test('Warning light is darker than warning dark', () {
      expect(
        AppTheme.warningLight.computeLuminance() <
            AppTheme.warningDark.computeLuminance(),
        true,
      );
    });
  });

  group('Color Extension Tests', () {
    test('contrastWith calculates correct ratio', () {
      const white = Colors.white;
      const black = Colors.black;
      
      final ratio = white.contrastWith(black);
      expect(ratio, closeTo(21.0, 0.1)); // White on black is 21:1
    });

    test('hasGoodContrastWith returns true for sufficient contrast', () {
      const white = Colors.white;
      const black = Colors.black;
      
      expect(white.hasGoodContrastWith(black), true);
    });

    test('hasGoodContrastWith returns false for insufficient contrast', () {
      const lightGray = Color(0xFFCCCCCC);
      const white = Colors.white;
      
      expect(lightGray.hasGoodContrastWith(white), false);
    });
  });

  group('Widget Theme Tests', () {
    testWidgets('Theme switches correctly in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: const Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      );

      // Verify light theme is applied
      final BuildContext context = tester.element(find.text('Test'));
      expect(Theme.of(context).brightness, Brightness.light);
    });

    testWidgets('Dark theme applies correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: const Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      );

      // Verify dark theme is applied
      final BuildContext context = tester.element(find.text('Test'));
      expect(Theme.of(context).brightness, Brightness.dark);
    });
  });
}
