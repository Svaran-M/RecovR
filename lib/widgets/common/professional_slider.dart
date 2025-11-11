import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Professional slider with 8px track, 28px thumb, and clear value labels
/// Implements requirements from task 7.2
class ProfessionalSlider extends StatelessWidget {
  const ProfessionalSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.showValueLabel = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.semanticFormatterCallback,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool showValueLabel;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String Function(double)? semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? 
        theme.colorScheme.surfaceContainerHighest;
    final effectiveThumbColor = thumbColor ?? effectiveActiveColor;
    
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // 8px track thickness
        trackHeight: 8.0,
        // 28px thumb (14px radius)
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 14.0,
          elevation: 2.0,
          pressedElevation: 4.0,
        ),
        // Large overlay for easy interaction
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 24.0,
        ),
        // Colors
        activeTrackColor: effectiveActiveColor,
        inactiveTrackColor: effectiveInactiveColor,
        thumbColor: effectiveThumbColor,
        overlayColor: effectiveActiveColor.withOpacity(0.12),
        // Value indicator styling - large, clear labels
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: effectiveActiveColor,
        valueIndicatorTextStyle: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        // Smooth animations
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: label ?? value.toStringAsFixed(0),
        onChanged: onChanged != null ? (newValue) {
          // Haptic feedback for smooth interaction
          HapticFeedback.selectionClick();
          onChanged!(newValue);
        } : null,
        semanticFormatterCallback: semanticFormatterCallback,
      ),
    );
  }
}

/// Professional slider with integrated label and value display
/// Perfect for forms and settings
class ProfessionalLabeledSlider extends StatelessWidget {
  const ProfessionalLabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.showValue = true,
    this.valueFormatter,
    this.activeColor,
    this.inactiveColor,
    this.minLabel,
    this.maxLabel,
  });

  final String label;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? minLabel;
  final String? maxLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedValue = valueFormatter?.call(value) ?? 
        value.toStringAsFixed(0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showValue)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
                decoration: BoxDecoration(
                  color: (activeColor ?? theme.colorScheme.primary)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  formattedValue,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: activeColor ?? theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        // Slider
        ProfessionalSlider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          showValueLabel: false, // We show it above instead
        ),
        // Min/Max labels
        if (minLabel != null || maxLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (minLabel != null)
                  Text(
                    minLabel!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                if (maxLabel != null)
                  Text(
                    maxLabel!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
