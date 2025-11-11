enum Difficulty { easy, medium, hard }

class Exercise {
  final String id;
  final String name;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;
  final Difficulty difficulty;
  final String category;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.isCompleted,
    this.completedAt,
    required this.difficulty,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'difficulty': difficulty.name,
      'category': category,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      category: json['category'] as String,
    );
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
    Difficulty? difficulty,
    String? category,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }
}
