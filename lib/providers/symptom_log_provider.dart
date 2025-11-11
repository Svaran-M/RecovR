import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/symptom_log.dart';
import '../repositories/symptom_log_repository.dart';
import '../repositories/local/local_symptom_log_repository.dart';

final symptomLogRepositoryProvider = Provider<SymptomLogRepository>((ref) {
  return LocalSymptomLogRepository();
});

class SymptomLogNotifier extends StateNotifier<List<SymptomLog>> {
  final SymptomLogRepository _repository;

  SymptomLogNotifier(this._repository) : super([]) {
    _loadSymptomLogs();
  }

  Future<void> _loadSymptomLogs() async {
    state = await _repository.getAll();
  }

  Future<void> addSymptomLog(SymptomLog log) async {
    await _repository.insert(log);
    state = [...state, log];
  }

  Future<void> removeSymptomLog(String logId) async {
    await _repository.delete(logId);
    state = state.where((log) => log.id != logId).toList();
  }

  Future<void> updateSymptomLog(SymptomLog updatedLog) async {
    await _repository.update(updatedLog);
    state = [
      for (final log in state)
        if (log.id == updatedLog.id) updatedLog else log,
    ];
  }

  List<SymptomLog> getLogsForDateRange(DateTime start, DateTime end) {
    return state.where((log) {
      return log.date.isAfter(start.subtract(const Duration(days: 1))) &&
          log.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  SymptomLog? getLatestLog() {
    if (state.isEmpty) return null;
    return state.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  double getAveragePainLevel(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentLogs =
        state.where((log) => log.date.isAfter(cutoffDate)).toList();

    if (recentLogs.isEmpty) return 0.0;

    final totalPain =
        recentLogs.fold<int>(0, (sum, log) => sum + log.painLevel);
    return totalPain / recentLogs.length;
  }
}

final symptomLogProvider =
    StateNotifierProvider<SymptomLogNotifier, List<SymptomLog>>((ref) {
  final repository = ref.watch(symptomLogRepositoryProvider);
  return SymptomLogNotifier(repository);
});
