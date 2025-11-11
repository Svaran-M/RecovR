class ROMMeasurement {
  final String id;
  final DateTime date;
  final String jointType;
  final double maxAngle;
  final String? sessionNotes;

  const ROMMeasurement({
    required this.id,
    required this.date,
    required this.jointType,
    required this.maxAngle,
    this.sessionNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'jointType': jointType,
      'maxAngle': maxAngle,
      'sessionNotes': sessionNotes,
    };
  }

  factory ROMMeasurement.fromJson(Map<String, dynamic> json) {
    return ROMMeasurement(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      jointType: json['jointType'] as String,
      maxAngle: (json['maxAngle'] as num).toDouble(),
      sessionNotes: json['sessionNotes'] as String?,
    );
  }

  ROMMeasurement copyWith({
    String? id,
    DateTime? date,
    String? jointType,
    double? maxAngle,
    String? sessionNotes,
  }) {
    return ROMMeasurement(
      id: id ?? this.id,
      date: date ?? this.date,
      jointType: jointType ?? this.jointType,
      maxAngle: maxAngle ?? this.maxAngle,
      sessionNotes: sessionNotes ?? this.sessionNotes,
    );
  }
}
