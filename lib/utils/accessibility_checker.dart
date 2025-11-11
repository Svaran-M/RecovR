import 'package:flutter/material.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';

/// Utility class to verify accessibility compliance for older users
/// Ensures touch targets, text sizes, and visual hierarchy meet requirements
class AccessibilityChecker {
  AccessibilityChecker._();
  
  // Minimum requirements for older users
  static const double minTouchTarget = 48.0;
  static const double preferredTouchTarget = 56.0;
  static const double minBodyTextSize = 18.0;
  static const double minLabelTextSize = 16.0;
  
  /// Verifies that a touch target meets minimum size requirements
  static bool verifyTouchTarget(double size, {bool preferred = false}) {
    final minSize = preferred ? preferredTouchTarget : minTouchTarget;
    return size >= minSize;
  }
  
  /// Verifies that text size is readable for older users
  static bool verifyTextSize(double fontSize, {bool isBodyText = true}) {
    final minSize = isBodyText ? minBodyTextSize : minLabelTextSize;
    return fontSize >= minSize;
  }
  
  /// Verifies that a widget has sufficient contrast
  static bool verifyContrast(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    
    final contrastRatio = (lighter + 0.05) / (darker + 0.05);
    
    // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
    return contrastRatio >= 4.5;
  }
  
  /// Verifies that spacing is sufficient for visual clarity
  static bool verifySpacing(double spacing) {
    // Minimum 8px spacing for clarity
    return spacing >= AppTheme.spacing8;
  }
  
  /// Creates a report of accessibility issues in the app
  static Map<String, List<String>> generateAccessibilityReport() {
    final issues = <String, List<String>>{};
    
    // Check theme compliance
    final themeIssues = <String>[];
    
    // Verify touch targets
    if (!verifyTouchTarget(AppTheme.touchTargetMinimum)) {
      themeIssues.add('Touch target minimum (${AppTheme.touchTargetMinimum}dp) is below 48dp');
    }
    
    // Verify button heights
    if (!verifyTouchTarget(AppTheme.buttonHeightStandard)) {
      themeIssues.add('Button height (${AppTheme.buttonHeightStandard}dp) is below 48dp');
    }
    
    // Verify checkbox size
    if (!verifyTouchTarget(AppTheme.checkboxSize)) {
      themeIssues.add('Checkbox size (${AppTheme.checkboxSize}dp) is below 48dp');
    }
    
    if (themeIssues.isNotEmpty) {
      issues['Theme'] = themeIssues;
    }
    
    return issues;
  }
  
  /// Widget wrapper that highlights accessibility issues in debug mode
  static Widget debugAccessibility({
    required Widget child,
    required String label,
    double? minWidth,
    double? minHeight,
    double? fontSize,
  }) {
    assert(() {
      final issues = <String>[];
      
      if (minWidth != null && !verifyTouchTarget(minWidth)) {
        issues.add('Width ${minWidth}dp < 48dp');
      }
      
      if (minHeight != null && !verifyTouchTarget(minHeight)) {
        issues.add('Height ${minHeight}dp < 48dp');
      }
      
      if (fontSize != null && !verifyTextSize(fontSize)) {
        issues.add('Font size ${fontSize}px < 18px');
      }
      
      if (issues.isNotEmpty) {
        debugPrint('⚠️ Accessibility issues in $label:');
        for (final issue in issues) {
          debugPrint('  - $issue');
        }
      }
      
      return true;
    }());
    
    return child;
  }
}

/// Extension on TextStyle to verify accessibility
extension TextStyleAccessibility on TextStyle {
  bool get isAccessible {
    final size = fontSize ?? 14.0;
    return AccessibilityChecker.verifyTextSize(size);
  }
  
  bool get isAccessibleForBody {
    final size = fontSize ?? 14.0;
    return size >= AccessibilityChecker.minBodyTextSize;
  }
  
  bool get isAccessibleForLabel {
    final size = fontSize ?? 14.0;
    return size >= AccessibilityChecker.minLabelTextSize;
  }
}

/// Extension on Size to verify touch target accessibility
extension SizeAccessibility on Size {
  bool get isTouchTargetAccessible {
    return width >= AccessibilityChecker.minTouchTarget &&
           height >= AccessibilityChecker.minTouchTarget;
  }
  
  bool get isTouchTargetPreferred {
    return width >= AccessibilityChecker.preferredTouchTarget &&
           height >= AccessibilityChecker.preferredTouchTarget;
  }
}

/// Mixin for widgets that need to verify accessibility
mixin AccessibilityVerification {
  void verifyAccessibility({
    required String widgetName,
    double? width,
    double? height,
    double? fontSize,
  }) {
    assert(() {
      if (width != null && height != null) {
        final size = Size(width, height);
        if (!size.isTouchTargetAccessible) {
          debugPrint('⚠️ $widgetName: Touch target ${width}x${height} is below 48x48dp');
        }
      }
      
      if (fontSize != null && !AccessibilityChecker.verifyTextSize(fontSize)) {
        debugPrint('⚠️ $widgetName: Font size ${fontSize}px is below 18px');
      }
      
      return true;
    }());
  }
}
