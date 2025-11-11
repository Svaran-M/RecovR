import 'package:flutter/material.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

/// Utility for testing theme switching and color contrast
class ThemeTester {
  ThemeTester._();
  
  /// Calculates contrast ratio between two colors
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  /// Checks if contrast ratio meets WCAG AA standard (4.5:1 for normal text)
  static bool meetsWCAGAA(Color foreground, Color background, {bool largeText = false}) {
    final ratio = calculateContrastRatio(foreground, background);
    final minRatio = largeText ? 3.0 : 4.5;
    return ratio >= minRatio;
  }
  
  /// Checks if contrast ratio meets WCAG AAA standard (7:1 for normal text)
  static bool meetsWCAGAAA(Color foreground, Color background, {bool largeText = false}) {
    final ratio = calculateContrastRatio(foreground, background);
    final minRatio = largeText ? 4.5 : 7.0;
    return ratio >= minRatio;
  }
  
  /// Tests all color combinations in light theme
  static Map<String, dynamic> testLightTheme() {
    final scheme = AppTheme.lightColorScheme;
    final results = <String, dynamic>{};
    
    // Test primary colors
    results['primary_on_surface'] = _testColorPair(
      'Primary on Surface',
      scheme.primary,
      scheme.surface,
    );
    
    results['on_primary_on_primary'] = _testColorPair(
      'OnPrimary on Primary',
      scheme.onPrimary,
      scheme.primary,
    );
    
    results['on_surface_on_surface'] = _testColorPair(
      'OnSurface on Surface',
      scheme.onSurface,
      scheme.surface,
    );
    
    results['secondary_on_surface'] = _testColorPair(
      'Secondary on Surface',
      scheme.secondary,
      scheme.surface,
    );
    
    results['error_on_surface'] = _testColorPair(
      'Error on Surface',
      scheme.error,
      scheme.surface,
    );
    
    results['on_primary_container_on_primary_container'] = _testColorPair(
      'OnPrimaryContainer on PrimaryContainer',
      scheme.onPrimaryContainer,
      scheme.primaryContainer,
    );
    
    return results;
  }
  
  /// Tests all color combinations in dark theme
  static Map<String, dynamic> testDarkTheme() {
    final scheme = AppTheme.darkColorScheme;
    final results = <String, dynamic>{};
    
    // Test primary colors
    results['primary_on_surface'] = _testColorPair(
      'Primary on Surface',
      scheme.primary,
      scheme.surface,
    );
    
    results['on_primary_on_primary'] = _testColorPair(
      'OnPrimary on Primary',
      scheme.onPrimary,
      scheme.primary,
    );
    
    results['on_surface_on_surface'] = _testColorPair(
      'OnSurface on Surface',
      scheme.onSurface,
      scheme.surface,
    );
    
    results['secondary_on_surface'] = _testColorPair(
      'Secondary on Surface',
      scheme.secondary,
      scheme.surface,
    );
    
    results['error_on_surface'] = _testColorPair(
      'Error on Surface',
      scheme.error,
      scheme.surface,
    );
    
    results['on_primary_container_on_primary_container'] = _testColorPair(
      'OnPrimaryContainer on PrimaryContainer',
      scheme.onPrimaryContainer,
      scheme.primaryContainer,
    );
    
    return results;
  }
  
  static Map<String, dynamic> _testColorPair(String name, Color foreground, Color background) {
    final ratio = calculateContrastRatio(foreground, background);
    final meetsAA = meetsWCAGAA(foreground, background);
    final meetsAAA = meetsWCAGAAA(foreground, background);
    
    return {
      'name': name,
      'ratio': ratio,
      'meetsAA': meetsAA,
      'meetsAAA': meetsAAA,
      'status': meetsAAA ? 'AAA' : (meetsAA ? 'AA' : 'FAIL'),
    };
  }
  
  /// Generates a comprehensive theme test report
  static void generateThemeReport() {
    debugPrint('=== Theme Contrast Testing ===\n');
    
    debugPrint('Light Theme:');
    final lightResults = testLightTheme();
    _printResults(lightResults);
    
    debugPrint('\nDark Theme:');
    final darkResults = testDarkTheme();
    _printResults(darkResults);
    
    debugPrint('\n=== Theme Test Complete ===');
  }
  
  static void _printResults(Map<String, dynamic> results) {
    for (final entry in results.values) {
      final name = entry['name'];
      final ratio = (entry['ratio'] as double).toStringAsFixed(2);
      final status = entry['status'];
      final icon = status == 'AAA' ? '✅' : (status == 'AA' ? '✓' : '❌');
      debugPrint('  $icon $name: $ratio:1 ($status)');
    }
  }
  
  /// Widget to preview theme switching
  static Widget themePreview(BuildContext context) {
    return Column(
      children: [
        _buildColorSwatch('Primary', Theme.of(context).colorScheme.primary),
        _buildColorSwatch('Secondary', Theme.of(context).colorScheme.secondary),
        _buildColorSwatch('Tertiary', Theme.of(context).colorScheme.tertiary),
        _buildColorSwatch('Error', Theme.of(context).colorScheme.error),
        _buildColorSwatch('Surface', Theme.of(context).colorScheme.surface),
        _buildColorSwatch('Background', Theme.of(context).colorScheme.background),
      ],
    );
  }
  
  static Widget _buildColorSwatch(String name, Color color) {
    return Container(
      height: 60,
      color: color,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Extension to make contrast checking easier
extension ColorContrast on Color {
  /// Checks contrast with another color
  double contrastWith(Color other) {
    return ThemeTester.calculateContrastRatio(this, other);
  }
  
  /// Checks if this color has sufficient contrast with another for WCAG AA
  bool hasGoodContrastWith(Color other, {bool largeText = false}) {
    return ThemeTester.meetsWCAGAA(this, other, largeText: largeText);
  }
  
  /// Checks if this color has sufficient contrast with another for WCAG AAA
  bool hasExcellentContrastWith(Color other, {bool largeText = false}) {
    return ThemeTester.meetsWCAGAAA(this, other, largeText: largeText);
  }
}
