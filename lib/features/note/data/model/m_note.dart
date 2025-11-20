import 'dart:convert';

class MNote {
  int id;
  String? title;
  String? points;
  String? details;
  DateTime? createdAt;
  DateTime? updatedAt;

  MNote({
    required this.id,
    this.title,
    this.points,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory MNote.fromMap(Map<String, dynamic> map) {
    return MNote(
      id: map["id"] as int,
      title: map['title'] as String?,
      points: map['points'] as String?,
      details: map['details'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      'title': title,
      'points': points,
      'details': details,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // --- Utility Methods ---

  // 4. Method to create MNote from a JSON string
  factory MNote.fromJson(String source) =>
      MNote.fromMap(json.decode(source) as Map<String, dynamic>);

  // 5. Method to convert MNote to a JSON string
  String toJson() => json.encode(toMap());

  // 6. toString() override for easy debugging/printing
  @override
  String toString() {
    return 'MNote(id: $id title: $title, points: $points, details: $details, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // 7. copyWith() for creating a new instance with optional changes
  MNote copyWith({
    int? id,
    String? title,
    String? points,
    String? details,
    DateTime? endAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finishedAt,
  }) {
    return MNote(
      id: id ?? this.id,
      title: title ?? this.title,
      points: points ?? this.points,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
