import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class SymptomSlider extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const SymptomSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  @override
  State<SymptomSlider> createState() => _SymptomSliderState();
}

class _SymptomSliderState extends State<SymptomSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading (22px)
        Text(
          widget.label,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Value display
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8, // 8px track
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14, // 28px diameter thumb
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24,
                  ),
                  activeTrackColor: _getSeverityColor(widget.value),
                  inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.2),
                  thumbColor: _getSeverityColor(widget.value),
                  overlayColor: _getSeverityColor(widget.value).withOpacity(0.2),
                ),
                child: Slider(
                  value: widget.value.toDouble(),
                  min: widget.min.toDouble(),
                  max: widget.max.toDouble(),
                  divisions: widget.max - widget.min,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    widget.onChanged(value.round());
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Large value label
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getSeverityColor(widget.value).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.value.toString(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: _getSeverityColor(widget.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                'High',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(int value) {
    final normalized = (value - widget.min) / (widget.max - widget.min);
    
    if (normalized < 0.33) {
      return AppTheme.success(context);
    } else if (normalized < 0.66) {
      return AppTheme.warning(context);
    } else {
      return AppTheme.error(context);
    }
  }
}

/// Symptom tracker widget combining multiple inputs
class SymptomTrackerWidget extends StatefulWidget {
  final Function(int painLevel, bool swelling, bool medicationTaken) onSubmit;

  const SymptomTrackerWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<SymptomTrackerWidget> createState() => _SymptomTrackerWidgetState();
}

class _SymptomTrackerWidgetState extends State<SymptomTrackerWidget> {
  int _painLevel = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SymptomSlider(
          label: 'Pain Level',
          value: _painLevel,
          onChanged: (value) {
            setState(() => _painLevel = value);
          },
          min: 1,
          max: 10,
        ),
        const SizedBox(height: 32),
        // Additional symptom inputs can be added here
      ],
    );
  }
}
