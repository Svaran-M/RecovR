import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Professional switch with clear on/off states and smooth animations
/// Implements requirements from task 7.3
class ProfessionalSwitch extends StatelessWidget {
  const ProfessionalSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: 56, // Larger switch for easy tapping
      height: AppTheme.checkboxSize,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Switch(
          value: value,
          onChanged: onChanged != null ? (newValue) {
            // Haptic feedback for clear interaction
            HapticFeedback.selectionClick();
            onChanged!(newValue);
          } : null,
          activeColor: activeColor ?? theme.colorScheme.primary,
          activeTrackColor: activeTrackColor ?? 
              theme.colorScheme.primaryContainer,
          inactiveThumbColor: inactiveThumbColor ?? 
              theme.colorScheme.outline,
          inactiveTrackColor: inactiveTrackColor ?? 
              theme.colorScheme.surfaceContainerHighest,
          // Smooth animation with Material 3 style
          splashRadius: 24,
        ),
      ),
    );
  }
}

/// Professional switch with integrated label
/// Perfect for settings and forms
class ProfessionalSwitchListTile extends StatelessWidget {
  const ProfessionalSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.contentPadding,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
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
            const SizedBox(width: AppTheme.spacing16),
            ProfessionalSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: activeColor,
              activeTrackColor: activeTrackColor,
              inactiveThumbColor: inactiveThumbColor,
              inactiveTrackColor: inactiveTrackColor,
            ),
          ],
        ),
      ),
    );
  }
}
