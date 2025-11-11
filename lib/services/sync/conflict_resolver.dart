enum ConflictResolutionStrategy {
  localWins,
  remoteWins,
  newerWins,
  manual,
}

class DataConflict<T> {
  final T localData;
  final T remoteData;
  final DateTime localTimestamp;
  final DateTime remoteTimestamp;

  const DataConflict({
    required this.localData,
    required this.remoteData,
    required this.localTimestamp,
    required this.remoteTimestamp,
  });
}

class ConflictResolver {
  final ConflictResolutionStrategy strategy;

  ConflictResolver({
    this.strategy = ConflictResolutionStrategy.newerWins,
  });

  T resolve<T>(DataConflict<T> conflict) {
    switch (strategy) {
      case ConflictResolutionStrategy.localWins:
        return conflict.localData;

      case ConflictResolutionStrategy.remoteWins:
        return conflict.remoteData;

      case ConflictResolutionStrategy.newerWins:
        return conflict.localTimestamp.isAfter(conflict.remoteTimestamp)
            ? conflict.localData
            : conflict.remoteData;

      case ConflictResolutionStrategy.manual:
        // In a real implementation, this would trigger a UI dialog
        // For now, default to newer wins
        return conflict.localTimestamp.isAfter(conflict.remoteTimestamp)
            ? conflict.localData
            : conflict.remoteData;
    }
  }

  List<T> resolveBatch<T>(List<DataConflict<T>> conflicts) {
    return conflicts.map((conflict) => resolve(conflict)).toList();
  }
}
