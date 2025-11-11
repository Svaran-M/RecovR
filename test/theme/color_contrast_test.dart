import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

void main() {
  group('Color Contrast Accessibility', () {
    /// Calculate relative luminance according to WCAG 2.1
    double _calculateLuminance(Color color) {
      return color.computeLuminance();
    }

    /// Calculate contrast ratio between two colors
    double _calculateContrastRatio(Color foreground, Color background) {
      final luminance1 = _calculateLuminance(foreground);
      final luminance2 = _calculateLuminance(background);
      
      final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
      final darker = luminance1 > luminance2 ? luminance2 : luminance1;
      
      return (lighter + 0.05) / (darker + 0.05);
    }

    /// Check if contrast ratio meets WCAG AA standard (4.5:1 for normal text)
    bool _meetsWCAGAA(double contrastRatio, {bool largeText = false}) {
      return largeText ? contrastRatio >= 3.0 : contrastRatio >= 4.5;
    }

    group('Text Readability - Light Theme', () {
      test('primary text on light background meets WCAG AA', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.black87,
          AppTheme.backgroundLight,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'Text contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });

      test('primary text on light surface meets WCAG AA', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.black87,
          AppTheme.surfaceLight,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'Text on surface contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });
    });

    group('Text Readability - Dark Theme', () {
      test('primary text on dark background meets WCAG AA', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.white,
          AppTheme.backgroundDark,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'Text contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });

      test('primary text on dark surface meets WCAG AA', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.white,
          AppTheme.surfaceDark,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'Text on surface contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });
    });

    group('Decorative Colors Visibility', () {
      test('geometric colors are visible on dark backgrounds', () {
        // These colors are used for decorative elements, gradients, and glassmorphism
        // They should be visible but don't need to meet strict text contrast standards
        final colors = [
          AppTheme.primaryGeometric,
          AppTheme.secondaryGeometric,
          AppTheme.accentGeometric,
        ];
        
        for (final color in colors) {
          final contrastRatio = _calculateContrastRatio(
            color,
            AppTheme.backgroundDark,
          );
          
          expect(
            contrastRatio >= 1.5,
            isTrue,
            reason: 'Color ${color.value.toRadixString(16)} should be visible: ${contrastRatio.toStringAsFixed(2)}:1',
          );
        }
      });

      test('accent colors provide visual interest', () {
        final colors = [
          AppTheme.neonPurple,
          AppTheme.electricBlue,
          AppTheme.neonGreen,
          AppTheme.vibrantOrange,
        ];
        
        for (final color in colors) {
          final darkRatio = _calculateContrastRatio(color, AppTheme.backgroundDark);
          final lightRatio = _calculateContrastRatio(color, AppTheme.backgroundLight);
          
          // Should be visible on at least one background
          expect(
            darkRatio >= 2.0 || lightRatio >= 2.0,
            isTrue,
            reason: 'Color ${color.value.toRadixString(16)} visible on dark: ${darkRatio.toStringAsFixed(2)}:1, light: ${lightRatio.toStringAsFixed(2)}:1',
          );
        }
      });
    });

    group('ColorScheme Text Contrast', () {
      test('light color scheme text colors meet standards', () {
        final scheme = AppTheme.lightColorScheme;
        final contrastRatio = _calculateContrastRatio(
          scheme.onSurface,
          scheme.surface,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'onSurface contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });

      test('dark color scheme text colors meet standards', () {
        final scheme = AppTheme.darkColorScheme;
        final contrastRatio = _calculateContrastRatio(
          scheme.onSurface,
          scheme.surface,
        );
        
        expect(
          _meetsWCAGAA(contrastRatio),
          isTrue,
          reason: 'onSurface contrast ratio: ${contrastRatio.toStringAsFixed(2)}:1',
        );
      });
    });

    group('Contrast Ratio Calculations', () {
      test('white on black has maximum contrast', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.white,
          Colors.black,
        );
        
        expect(contrastRatio, closeTo(21.0, 0.1));
      });

      test('same color has minimum contrast', () {
        final contrastRatio = _calculateContrastRatio(
          Colors.blue,
          Colors.blue,
        );
        
        expect(contrastRatio, equals(1.0));
      });

      test('contrast ratio is symmetric', () {
        final ratio1 = _calculateContrastRatio(
          AppTheme.primaryGeometric,
          AppTheme.backgroundDark,
        );
        final ratio2 = _calculateContrastRatio(
          AppTheme.backgroundDark,
          AppTheme.primaryGeometric,
        );
        
        expect(ratio1, equals(ratio2));
      });
    });
  });

  group('Theme Color Scheme Tests', () {
    testWidgets('light theme applies correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              
              expect(theme.brightness, equals(Brightness.light));
              expect(theme.colorScheme.primary, equals(AppTheme.primaryGeometric));
              expect(theme.colorScheme.secondary, equals(AppTheme.secondaryGeometric));
              expect(theme.scaffoldBackgroundColor, equals(AppTheme.backgroundLight));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });

    testWidgets('dark theme applies correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              
              expect(theme.brightness, equals(Brightness.dark));
              expect(theme.colorScheme.primary, equals(AppTheme.primaryGeometric));
              expect(theme.colorScheme.secondary, equals(AppTheme.secondaryGeometric));
              expect(theme.scaffoldBackgroundColor, equals(AppTheme.backgroundDark));
              
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );
    });
  });
}
