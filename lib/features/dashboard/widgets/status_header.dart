import 'package:flutter/material.dart';
import 'package:rehab_tracker_pro/theme/app_theme.dart';
import 'package:rehab_tracker_pro/utils/spacing_utils.dart';

/// Professional status header with clean typography and generous spacing
/// Displays recovery points and level without geometric shapes
class StatusHeader extends StatelessWidget {
  final int recoveryPoints;
  final int currentLevel;

  const StatusHeader({
    super.key,
    required this.recoveryPoints,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing32,
        AppTheme.spacing48,
        AppTheme.spacing32,
        AppTheme.spacing32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting text
          Text(
            'Your Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SpacingUtils.vertical16,
          
          // Recovery points - large, elegant number
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '$recoveryPoints',
                  key: ValueKey<int>(recoveryPoints),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    color: colorScheme.primary,
                    height: 1.0,
                    letterSpacing: -2,
                  ),
                ),
              ),
              SpacingUtils.horizontal12,
              Text(
                'points',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SpacingUtils.vertical12,
          
          // Level badge - subtle inline element
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: currentLevel.toDouble()),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium + 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: AppTheme.iconSizeSmall,
                      color: colorScheme.primary,
                    ),
                    SpacingUtils.horizontal8,
                    Text(
                      'Level ${value.floor()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
