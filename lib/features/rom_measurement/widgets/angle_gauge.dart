import 'package:flutter/material.dart';

class AngleGauge extends StatelessWidget {
  final double angle;
  final bool isActive;

  const AngleGauge({
    super.key,
    required this.angle,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Massive angle display - 120px font
        Text(
          angle.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.w300,
            height: 1.0,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Unit label - 24px font
        Text(
          'degrees',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
