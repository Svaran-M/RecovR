import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehab_tracker_pro/providers/rom_measurement_provider.dart';
import 'package:rehab_tracker_pro/models/rom_measurement.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ROMMeasurementNotifier - State Updates', () {
    test('adds ROM measurement', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 120.5,
        sessionNotes: 'Good progress',
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      final measurements = container.read(romMeasurementProvider);
      expect(measurements.length, 1);
      expect(measurements[0].maxAngle, 120.5);
      expect(measurements[0].jointType, 'shoulder');
      
      container.dispose();
    });

    test('removes ROM measurement', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'knee',
        maxAngle: 90.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      container.read(romMeasurementProvider.notifier).removeMeasurement('1');
      await Future.delayed(const Duration(milliseconds: 300));

      final measurements = container.read(romMeasurementProvider);
      expect(measurements, isEmpty);
      
      container.dispose();
    });

    test('updates ROM measurement', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'elbow',
        maxAngle: 100.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedMeasurement = measurement.copyWith(
        maxAngle: 110.0,
        sessionNotes: 'Improved',
      );
      container.read(romMeasurementProvider.notifier).updateMeasurement(updatedMeasurement);
      await Future.delayed(const Duration(milliseconds: 300));

      final measurements = container.read(romMeasurementProvider);
      expect(measurements[0].maxAngle, 110.0);
      expect(measurements[0].sessionNotes, 'Improved');
      
      container.dispose();
    });
  });

  group('ROMMeasurementNotifier - Queries', () {
    test('gets measurements for specific joint', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement1 = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: DateTime.now(),
        jointType: 'knee',
        maxAngle: 90.0,
      );
      final measurement3 = ROMMeasurement(
        id: '3',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 125.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement3);
      await Future.delayed(const Duration(milliseconds: 300));

      final shoulderMeasurements = container.read(romMeasurementProvider.notifier)
          .getMeasurementsForJoint('shoulder');

      expect(shoulderMeasurements.length, 2);
      expect(shoulderMeasurements.every((m) => m.jointType == 'shoulder'), true);
      
      container.dispose();
    });

    test('gets measurements for date range', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 125.0,
      );
      final measurement3 = ROMMeasurement(
        id: '3',
        date: now.subtract(const Duration(days: 10)),
        jointType: 'shoulder',
        maxAngle: 115.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement3);
      await Future.delayed(const Duration(milliseconds: 300));

      final start = now.subtract(const Duration(days: 7));
      final end = now;
      final filteredMeasurements = container.read(romMeasurementProvider.notifier)
          .getMeasurementsForDateRange(start, end);

      expect(filteredMeasurements.length, 2);
      expect(filteredMeasurements.any((m) => m.id == '1'), true);
      expect(filteredMeasurements.any((m) => m.id == '2'), true);
      expect(filteredMeasurements.any((m) => m.id == '3'), false);
      
      container.dispose();
    });

    test('gets latest measurement for joint', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 125.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      await Future.delayed(const Duration(milliseconds: 300));

      final latestMeasurement = container.read(romMeasurementProvider.notifier)
          .getLatestMeasurement('shoulder');

      expect(latestMeasurement?.id, '2');
      expect(latestMeasurement?.maxAngle, 125.0);
      
      container.dispose();
    });

    test('calculates average ROM for joint', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 130.0,
      );
      final measurement3 = ROMMeasurement(
        id: '3',
        date: now.subtract(const Duration(days: 3)),
        jointType: 'shoulder',
        maxAngle: 125.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement3);
      await Future.delayed(const Duration(milliseconds: 300));

      final avgROM = container.read(romMeasurementProvider.notifier)
          .getAverageROM('shoulder', 7);

      expect(avgROM, 125.0);
      
      container.dispose();
    });

    test('calculates improvement percentage', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        jointType: 'shoulder',
        maxAngle: 100.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      await Future.delayed(const Duration(milliseconds: 300));

      final improvement = container.read(romMeasurementProvider.notifier)
          .getImprovementPercentage('shoulder', 7);

      expect(improvement, 20.0);
      
      container.dispose();
    });
  });

  group('ROMMeasurementNotifier - Persistence', () {
    test('persists data to shared_preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 120.5,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('rom_measurements');
      expect(savedData, isNotNull);
      expect(savedData, contains('120.5'));
      
      container.dispose();
    });
  });

  group('ROMMeasurementNotifier - Edge Cases', () {
    test('handles empty measurements for joint', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurements = container.read(romMeasurementProvider.notifier)
          .getMeasurementsForJoint('shoulder');

      expect(measurements, isEmpty);
      
      container.dispose();
    });

    test('handles latest measurement when none exist', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final latestMeasurement = container.read(romMeasurementProvider.notifier)
          .getLatestMeasurement('shoulder');

      expect(latestMeasurement, isNull);
      
      container.dispose();
    });

    test('handles average ROM with no measurements', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final avgROM = container.read(romMeasurementProvider.notifier)
          .getAverageROM('shoulder', 7);

      expect(avgROM, isNull);
      
      container.dispose();
    });

    test('handles improvement percentage with insufficient data', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      final improvement = container.read(romMeasurementProvider.notifier)
          .getImprovementPercentage('shoulder', 7);

      expect(improvement, isNull);
      
      container.dispose();
    });

    test('handles improvement percentage with zero initial angle', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        jointType: 'shoulder',
        maxAngle: 0.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      await Future.delayed(const Duration(milliseconds: 300));

      final improvement = container.read(romMeasurementProvider.notifier)
          .getImprovementPercentage('shoulder', 7);

      expect(improvement, isNull);
      
      container.dispose();
    });

    test('handles negative improvement (regression)', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final measurement1 = ROMMeasurement(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );
      final measurement2 = ROMMeasurement(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        jointType: 'shoulder',
        maxAngle: 100.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement1);
      container.read(romMeasurementProvider.notifier).addMeasurement(measurement2);
      await Future.delayed(const Duration(milliseconds: 300));

      final improvement = container.read(romMeasurementProvider.notifier)
          .getImprovementPercentage('shoulder', 7);

      expect(improvement, closeTo(-16.67, 0.01));
      
      container.dispose();
    });

    test('handles remove non-existent measurement', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final measurement = ROMMeasurement(
        id: '1',
        date: DateTime.now(),
        jointType: 'shoulder',
        maxAngle: 120.0,
      );

      container.read(romMeasurementProvider.notifier).addMeasurement(measurement);
      await Future.delayed(const Duration(milliseconds: 300));

      container.read(romMeasurementProvider.notifier).removeMeasurement('non-existent');
      await Future.delayed(const Duration(milliseconds: 300));

      final measurements = container.read(romMeasurementProvider);
      expect(measurements.length, 1);
      
      container.dispose();
    });
  });
}
