class SymptomLog {
  final String id;
  final DateTime date;
  final int painLevel; // 1-10
  final bool swelling;
  final bool medicationTaken;
  final String? notes;

  const SymptomLog({
    required this.id,
    required this.date,
    required this.painLevel,
    required this.swelling,
    required this.medicationTaken,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'painLevel': painLevel,
      'swelling': swelling,
      'medicationTaken': medicationTaken,
      'notes': notes,
    };
  }

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      painLevel: json['painLevel'] as int,
      swelling: json['swelling'] as bool,
      medicationTaken: json['medicationTaken'] as bool,
      notes: json['notes'] as String?,
    );
  }

  SymptomLog copyWith({
    String? id,
    DateTime? date,
    int? painLevel,
    bool? swelling,
    bool? medicationTaken,
    String? notes,
  }) {
    return SymptomLog(
      id: id ?? this.id,
      date: date ?? this.date,
      painLevel: painLevel ?? this.painLevel,
      swelling: swelling ?? this.swelling,
      medicationTaken: medicationTaken ?? this.medicationTaken,
      notes: notes ?? this.notes,
    );
  }
}
