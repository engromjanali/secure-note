import 'dart:convert';

class MTask {
  int id;
  String? title;
  String? points;
  String? details;
  DateTime? endAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? finishedAt;

  MTask({
    required this.id,
    this.title,
    this.points,
    this.details,
    this.endAt,
    this.createdAt,
    this.updatedAt,
    this.finishedAt,
  });

  factory MTask.fromMap(Map<String, dynamic> map) {
    return MTask(
      id: map["id"] as int,
      title: map['title'] as String?,
      points: map['points'] as String?,
      details: map['details'] as String?,
      endAt: map['endAt'] != null
          ? DateTime.parse(map['endAt'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      finishedAt: map['finishedAt'] != null
          ? DateTime.parse(map['finishedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      'title': title,
      'points': points,
      'details': details,
      'endAt': endAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
    };
  }

  // --- Utility Methods ---

  // 4. Method to create MTask from a JSON string
  factory MTask.fromJson(String source) =>
      MTask.fromMap(json.decode(source) as Map<String, dynamic>);

  // 5. Method to convert MTask to a JSON string
  String toJson() => json.encode(toMap());

  // 6. toString() override for easy debugging/printing
  @override
  String toString() {
    return 'MTask(id: $id title: $title, points: $points, details: $details, endAt: $endAt, createdAt: $createdAt, updatedAt: $updatedAt, finishedAt: $finishedAt)';
  }

  // 7. copyWith() for creating a new instance with optional changes
  MTask copyWith({
    int? id,
    String? title,
    String? points,
    String? details,
    DateTime? endAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) {
    return MTask(
      id: id ?? this.id,
      title: title ?? this.title,
      points: points ?? this.points,
      details: details ?? this.details,
      endAt: endAt ?? this.endAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}

