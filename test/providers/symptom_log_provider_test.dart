import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehab_tracker_pro/providers/symptom_log_provider.dart';
import 'package:rehab_tracker_pro/models/symptom_log.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SymptomLogNotifier - State Updates', () {
    test('adds symptom log', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
        notes: 'Test note',
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log);
      await Future.delayed(const Duration(milliseconds: 300));

      final logs = container.read(symptomLogProvider);
      expect(logs.length, 1);
      expect(logs[0].painLevel, 5);
      expect(logs[0].swelling, true);
      
      container.dispose();
    });

    test('removes symptom log', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log);
      await Future.delayed(const Duration(milliseconds: 300));

      container.read(symptomLogProvider.notifier).removeSymptomLog('1');
      await Future.delayed(const Duration(milliseconds: 300));

      final logs = container.read(symptomLogProvider);
      expect(logs, isEmpty);
      
      container.dispose();
    });

    test('updates symptom log', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log);
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedLog = log.copyWith(painLevel: 8, medicationTaken: true);
      container.read(symptomLogProvider.notifier).updateSymptomLog(updatedLog);
      await Future.delayed(const Duration(milliseconds: 300));

      final logs = container.read(symptomLogProvider);
      expect(logs[0].painLevel, 8);
      expect(logs[0].medicationTaken, true);
      
      container.dispose();
    });
  });

  group('SymptomLogNotifier - Queries', () {
    test('gets logs for date range', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final log1 = SymptomLog(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );
      final log2 = SymptomLog(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        painLevel: 3,
        swelling: false,
        medicationTaken: true,
      );
      final log3 = SymptomLog(
        id: '3',
        date: now.subtract(const Duration(days: 10)),
        painLevel: 7,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log1);
      container.read(symptomLogProvider.notifier).addSymptomLog(log2);
      container.read(symptomLogProvider.notifier).addSymptomLog(log3);
      await Future.delayed(const Duration(milliseconds: 300));

      final start = now.subtract(const Duration(days: 7));
      final end = now;
      final filteredLogs = container.read(symptomLogProvider.notifier)
          .getLogsForDateRange(start, end);

      expect(filteredLogs.length, 2);
      expect(filteredLogs.any((log) => log.id == '1'), true);
      expect(filteredLogs.any((log) => log.id == '2'), true);
      expect(filteredLogs.any((log) => log.id == '3'), false);
      
      container.dispose();
    });

    test('gets latest log', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final log1 = SymptomLog(
        id: '1',
        date: now.subtract(const Duration(days: 5)),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );
      final log2 = SymptomLog(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        painLevel: 3,
        swelling: false,
        medicationTaken: true,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log1);
      container.read(symptomLogProvider.notifier).addSymptomLog(log2);
      await Future.delayed(const Duration(milliseconds: 300));

      final latestLog = container.read(symptomLogProvider.notifier).getLatestLog();
      expect(latestLog?.id, '2');
      expect(latestLog?.painLevel, 3);
      
      container.dispose();
    });

    test('calculates average pain level', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final log1 = SymptomLog(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        painLevel: 4,
        swelling: true,
        medicationTaken: false,
      );
      final log2 = SymptomLog(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        painLevel: 6,
        swelling: false,
        medicationTaken: true,
      );
      final log3 = SymptomLog(
        id: '3',
        date: now.subtract(const Duration(days: 3)),
        painLevel: 8,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log1);
      container.read(symptomLogProvider.notifier).addSymptomLog(log2);
      container.read(symptomLogProvider.notifier).addSymptomLog(log3);
      await Future.delayed(const Duration(milliseconds: 300));

      final avgPain = container.read(symptomLogProvider.notifier)
          .getAveragePainLevel(7);
      expect(avgPain, 6.0);
      
      container.dispose();
    });
  });

  group('SymptomLogNotifier - Persistence', () {
    test('persists data to shared_preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log);
      await Future.delayed(const Duration(milliseconds: 300));

      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('symptom_logs');
      expect(savedData, isNotNull);
      expect(savedData, contains('"painLevel":5'));
      
      container.dispose();
    });
  });

  group('SymptomLogNotifier - Edge Cases', () {
    test('handles empty logs for date range', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 7));
      final end = now;
      final filteredLogs = container.read(symptomLogProvider.notifier)
          .getLogsForDateRange(start, end);

      expect(filteredLogs, isEmpty);
      
      container.dispose();
    });

    test('handles latest log when empty', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final latestLog = container.read(symptomLogProvider.notifier).getLatestLog();
      expect(latestLog, isNull);
      
      container.dispose();
    });

    test('handles average pain level with no logs', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final avgPain = container.read(symptomLogProvider.notifier)
          .getAveragePainLevel(7);
      expect(avgPain, 0.0);
      
      container.dispose();
    });

    test('handles pain level boundaries (1-10)', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log1 = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 1,
        swelling: false,
        medicationTaken: false,
      );
      final log2 = SymptomLog(
        id: '2',
        date: DateTime.now(),
        painLevel: 10,
        swelling: true,
        medicationTaken: true,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log1);
      container.read(symptomLogProvider.notifier).addSymptomLog(log2);
      await Future.delayed(const Duration(milliseconds: 300));

      final logs = container.read(symptomLogProvider);
      expect(logs[0].painLevel, 1);
      expect(logs[1].painLevel, 10);
      
      container.dispose();
    });

    test('handles remove non-existent log', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(seconds: 1));

      final log = SymptomLog(
        id: '1',
        date: DateTime.now(),
        painLevel: 5,
        swelling: true,
        medicationTaken: false,
      );

      container.read(symptomLogProvider.notifier).addSymptomLog(log);
      await Future.delayed(const Duration(milliseconds: 300));

      container.read(symptomLogProvider.notifier).removeSymptomLog('non-existent');
      await Future.delayed(const Duration(milliseconds: 300));

      final logs = container.read(symptomLogProvider);
      expect(logs.length, 1);
      
      container.dispose();
    });
  });
}
