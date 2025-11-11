import 'package:flutter/material.dart';
import '../../../models/rom_measurement.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/spacing_utils.dart';
import 'instruction_display.dart';
import 'angle_gauge.dart';
import '../../../widgets/common/action_button.dart';

enum MeasurementState { idle, ready, measuring, complete }

class ROMInterface extends StatefulWidget {
  final List<ROMMeasurement> measurements;
  final VoidCallback onStartMeasurement;
  final VoidCallback onCompleteMeasurement;

  const ROMInterface({
    super.key,
    required this.measurements,
    required this.onStartMeasurement,
    required this.onCompleteMeasurement,
  });

  @override
  State<ROMInterface> createState() => _ROMInterfaceState();
}

class _ROMInterfaceState extends State<ROMInterface>
    with SingleTickerProviderStateMixin {
  MeasurementState _state = MeasurementState.idle;
  double _currentAngle = 0.0;
  late AnimationController _angleController;

  @override
  void initState() {
    super.initState();
    _angleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _angleController.dispose();
    super.dispose();
  }

  void _startMeasurement() {
    setState(() {
      _state = MeasurementState.ready;
      _currentAngle = 0.0;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _state == MeasurementState.ready) {
        setState(() {
          _state = MeasurementState.measuring;
        });
        _simulateMeasurement();
      }
    });
    
    widget.onStartMeasurement();
  }

  void _simulateMeasurement() {
    _angleController.reset();
    _angleController.forward();
    
    _angleController.addListener(() {
      if (mounted) {
        setState(() {
          _currentAngle = _angleController.value * 120.0;
        });
      }
    });

    _angleController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _state = MeasurementState.complete;
        });
      }
    });
  }

  void _completeMeasurement() {
    widget.onCompleteMeasurement();
    setState(() {
      _state = MeasurementState.idle;
      _currentAngle = 0.0;
    });
  }

  void _reset() {
    setState(() {
      _state = MeasurementState.idle;
      _currentAngle = 0.0;
    });
    _angleController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 28,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Instruction display
            InstructionDisplay(state: _state),

            SpacingUtils.vertical48,

            // Angle gauge - clean, focused display
            AngleGauge(
              angle: _currentAngle,
              isActive: _state == MeasurementState.measuring,
            ),

            const Spacer(),

            // Action buttons
            Padding(
              padding: SpacingUtils.paddingH24,
              child: _buildActionButtons(theme),
            ),

            SpacingUtils.vertical32,

            // Legal disclaimer - subtle at bottom
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing32,
                vertical: AppTheme.spacing16,
              ),
              child: Text(
                'For informational purposes only. Not a medical diagnostic tool.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    switch (_state) {
      case MeasurementState.idle:
        return ActionButton.primary(
          label: 'Start Measurement',
          onPressed: _startMeasurement,
          icon: Icons.play_arrow,
        );

      case MeasurementState.ready:
      case MeasurementState.measuring:
        return ActionButton.primary(
          label: _state == MeasurementState.ready
              ? 'Preparing...'
              : 'Measuring...',
          onPressed: null,
          icon: Icons.sensors,
        );

      case MeasurementState.complete:
        return Row(
          children: [
            Expanded(
              child: ActionButton.secondary(
                label: 'Retry',
                onPressed: _reset,
                icon: Icons.refresh,
              ),
            ),
            SpacingUtils.horizontal16,
            Expanded(
              child: ActionButton.primary(
                label: 'Save',
                onPressed: _completeMeasurement,
                icon: Icons.check,
              ),
            ),
          ],
        );
    }
  }
}
