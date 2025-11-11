import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Professional checkbox with 32px size for easy tapping
/// Implements requirements from task 7.3
class ProfessionalCheckbox extends StatelessWidget {
  const ProfessionalCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.shape,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: AppTheme.checkboxSize,
      height: AppTheme.checkboxSize,
      child: Transform.scale(
        scale: 1.33, // Scale up to achieve 32px from default 24px
        child: Checkbox(
          value: value,
          onChanged: onChanged != null ? (newValue) {
            // Haptic feedback for clear interaction
            HapticFeedback.selectionClick();
            onChanged!(newValue);
          } : null,
          activeColor: activeColor ?? theme.colorScheme.primary,
          checkColor: checkColor ?? theme.colorScheme.onPrimary,
          tristate: tristate,
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(
            color: theme.colorScheme.outline,
            width: 2,
          ),
          // Smooth animation
          splashRadius: 24,
        ),
      ),
    );
  }
}

/// Professional checkbox with integrated label
/// Perfect for forms and lists
class ProfessionalCheckboxListTile extends StatelessWidget {
  const ProfessionalCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.activeColor,
    this.checkColor,
    this.contentPadding,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Color? activeColor;
  final Color? checkColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: enabled && onChanged != null ? () {
        HapticFeedback.selectionClick();
        onChanged!(!value);
      } : null,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        ),
        child: Row(
          children: [
            ProfessionalCheckbox(
              value: value,
              onChanged: enabled ? (newValue) {
                if (newValue != null) {
                  onChanged?.call(newValue);
                }
              } : null,
              activeColor: activeColor,
              checkColor: checkColor,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ) ?? const TextStyle(),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ) ?? const TextStyle(),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
