import 'package:flutter/material.dart';
import 'dart:math' as math;

// Accessibility helpers
class AccessibilityUtils {
  // min touch target per WCAG (48x48)
  static const double minTouchTargetSize = 48.0;

  static Widget ensureTouchTarget({
    required Widget child,
    double minSize = minTouchTargetSize,
    VoidCallback? onTap,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: onTap != null
          ? GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: child,
            )
          : child,
    );
  }

  static Widget withSemantics({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool? button,
    bool? header,
    bool? link,
    bool? image,
    bool? selected,
    bool? enabled,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      link: link,
      image: image,
      selected: selected,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      child: child,
    );
  }

  static Widget accessibleButton({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
    String? hint,
    bool enabled = true,
  }) {
    return ensureTouchTarget(
      onTap: enabled ? onPressed : null,
      child: withSemantics(
        label: label,
        hint: hint,
        button: true,
        enabled: enabled,
        onTap: enabled ? onPressed : null,
        child: child,
      ),
    );
  }

  // checks if contrast meets WCAG AA (4.5:1)
  static bool meetsContrastRatio(
    Color foreground,
    Color background, {
    double minimumRatio = 4.5,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= minimumRatio;
  }

  static double calculateContrastRatio(Color color1, Color color2) {
    final l1 = _relativeLuminance(color1);
    final l2 = _relativeLuminance(color2);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }
    return math.pow((component + 0.055) / 1.055, 2.4).toDouble();
  }

  static Widget accessibleText({
    required String text,
    TextStyle? style,
    bool isHeader = false,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? text,
      header: isHeader,
      child: Text(text, style: style),
    );
  }

  static Widget accessibleIcon({
    required IconData icon,
    required String label,
    Color? color,
    double? size,
  }) {
    return Semantics(
      label: label,
      image: true,
      child: ExcludeSemantics(
        child: Icon(icon, color: color, size: size),
      ),
    );
  }

  // hides decorative elements from screen readers
  static Widget decorative(Widget child) {
    return ExcludeSemantics(child: child);
  }

  static Widget liveRegion({
    required Widget child,
    required String label,
    bool assertive = false,
  }) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: child,
    );
  }

  static Future<void> announce(BuildContext context, String message) async {
    // will use SemanticsService.announce in production
    debugPrint('Accessibility announcement: $message');
  }

  static Widget accessibleSlider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String label,
    String Function(double)? valueFormatter,
  }) {
    final currentValue = valueFormatter?.call(value) ?? value.toStringAsFixed(0);
    final increasedValue = value < max 
        ? (valueFormatter?.call(value + 1) ?? (value + 1).toStringAsFixed(0))
        : currentValue;
    final decreasedValue = value > min
        ? (valueFormatter?.call(value - 1) ?? (value - 1).toStringAsFixed(0))
        : currentValue;
    
    return Semantics(
      label: label,
      value: currentValue,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      onIncrease: value < max
          ? () => onChanged((value + 1).clamp(min, max))
          : null,
      onDecrease: value > min
          ? () => onChanged((value - 1).clamp(min, max))
          : null,
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }

  static Widget accessibleToggle({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
    String? enabledHint,
    String? disabledHint,
  }) {
    final currentValue = value ? (enabledHint ?? 'On') : (disabledHint ?? 'Off');
    final increasedValue = !value ? (enabledHint ?? 'On') : currentValue;
    final decreasedValue = value ? (disabledHint ?? 'Off') : currentValue;
    
    return Semantics(
      label: label,
      value: currentValue,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      toggled: value,
      onTap: () => onChanged(!value),
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
