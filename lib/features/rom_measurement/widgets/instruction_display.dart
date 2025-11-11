import 'package:flutter/material.dart';
import 'rom_interface.dart';

class InstructionDisplay extends StatelessWidget {
  final MeasurementState state;

  const InstructionDisplay({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Simple step indicator
        _buildStepIndicator(context, state),

        const SizedBox(height: 32),

        // Instruction text - large and clear
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
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
          child: _buildInstructionText(context, state),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(BuildContext context, MeasurementState state) {
    final theme = Theme.of(context);
    final steps = [
      MeasurementState.idle,
      MeasurementState.ready,
      MeasurementState.measuring,
      MeasurementState.complete,
    ];
    final currentStep = steps.indexOf(state);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 32 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            if (index < steps.length - 1)
              Container(
                width: 24,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
              ),
          ],
        );
      }),
    );
  }

  Widget _buildInstructionText(BuildContext context, MeasurementState state) {
    final theme = Theme.of(context);
    final instruction = _getInstructionText(state);
    final subtitle = _getSubtitleText(state);

    return Padding(
      key: ValueKey(state),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large, clear instruction text - 22px
          Text(
            instruction,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _getInstructionText(MeasurementState state) {
    switch (state) {
      case MeasurementState.idle:
        return 'Ready to Measure';
      case MeasurementState.ready:
        return 'Get Ready';
      case MeasurementState.measuring:
        return 'Begin Movement';
      case MeasurementState.complete:
        return 'Measurement Complete';
    }
  }

  String? _getSubtitleText(MeasurementState state) {
    switch (state) {
      case MeasurementState.idle:
        return 'Position yourself and tap Start Measurement';
      case MeasurementState.ready:
        return 'Hold your starting position';
      case MeasurementState.measuring:
        return 'Move slowly through your full range';
      case MeasurementState.complete:
        return 'Review your measurement and save';
    }
  }

}
