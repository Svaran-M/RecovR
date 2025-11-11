import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/rom_measurement.dart';
import '../../providers/rom_measurement_provider.dart';
import '../../providers/user_progress_provider.dart';
import 'widgets/rom_interface.dart';
import 'widgets/instruction_display.dart';
import 'widgets/measurement_input_dialog.dart';

class ROMScreen extends ConsumerStatefulWidget {
  const ROMScreen({super.key});

  @override
  ConsumerState<ROMScreen> createState() => _ROMScreenState();
}

class _ROMScreenState extends ConsumerState<ROMScreen> {
  @override
  Widget build(BuildContext context) {
    final measurements = ref.watch(romMeasurementProvider);

    return ROMInterface(
      measurements: measurements,
      onStartMeasurement: () {
        // Start measurement flow
      },
      onCompleteMeasurement: () async {
        try {
          // Show input dialog
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => const MeasurementInputDialog(),
          );
          
          if (result != null && mounted) {
            final measurement = ROMMeasurement(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.now(),
              jointType: result['jointType'] as String,
              maxAngle: result['maxAngle'] as double,
              sessionNotes: result['sessionNotes'] as String?,
            );
            
            await ref.read(romMeasurementProvider.notifier).addMeasurement(measurement);
            
            // Award points for completing ROM measurement
            await ref.read(userProgressProvider.notifier).addRecoveryPoints(15);
            
            // Show success message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('ROM measurement saved! +15 points'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            }
          }
        } catch (e) {
          // Handle error
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving measurement: ${e.toString()}'),
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      },
    );
  }
}
