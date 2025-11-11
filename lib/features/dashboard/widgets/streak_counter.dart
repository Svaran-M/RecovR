import 'package:flutter/material.dart';

/// Simple streak counter stat with icon
/// Displays streak count in a clean, professional manner
class StreakCounter extends StatelessWidget {
  final int streakCount;
  final double size;

  const StreakCounter({
    super.key,
    required this.streakCount,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Scale elements based on size
    final iconSize = size * 0.28;
    final numberSize = size * 0.26;
    final labelSize = size * 0.10;
    final padding = size * 0.11;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: streakCount.toDouble()),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedCount, child) {
        return Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fire icon
              Icon(
                Icons.local_fire_department_rounded,
                size: iconSize,
                color: colorScheme.secondary,
              ),
              SizedBox(height: size * 0.06),
              // Streak count
              Text(
                '${animatedCount.toInt()}',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontSize: numberSize,
                  height: 1.0,
                ),
              ),
              SizedBox(height: size * 0.02),
              // Label
              Text(
                'Day Streak',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: labelSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
