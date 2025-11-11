class UserProgress {
  final String id;
  final int recoveryPoints;
  final int currentLevel;
  final int streakCount;
  final DateTime lastActivity;
  final double completionPercentage;

  const UserProgress({
    required this.id,
    required this.recoveryPoints,
    required this.currentLevel,
    required this.streakCount,
    required this.lastActivity,
    required this.completionPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recoveryPoints': recoveryPoints,
      'currentLevel': currentLevel,
      'streakCount': streakCount,
      'lastActivity': lastActivity.toIso8601String(),
      'completionPercentage': completionPercentage,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'] as String,
      recoveryPoints: json['recoveryPoints'] as int,
      currentLevel: json['currentLevel'] as int,
      streakCount: json['streakCount'] as int,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
    );
  }

  UserProgress copyWith({
    String? id,
    int? recoveryPoints,
    int? currentLevel,
    int? streakCount,
    DateTime? lastActivity,
    double? completionPercentage,
  }) {
    return UserProgress(
      id: id ?? this.id,
      recoveryPoints: recoveryPoints ?? this.recoveryPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      streakCount: streakCount ?? this.streakCount,
      lastActivity: lastActivity ?? this.lastActivity,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}
