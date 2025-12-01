import 'dart:convert';

class MSocial {
  String? id;
  String? title;
  String? pass;
  String? bCode;
  String? note;
  DateTime? createdAt;
  DateTime? updatedAt;


  MSocial({
     this.id,
    this.title,
    this.pass,
    this.bCode,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory MSocial.fromMap(Map<String, dynamic> map) {
    return MSocial(
      id: map["id"] as String,
      title: map['title'] as String?,
      pass: map['pass'] as String?,
      bCode: map['bCode'] as String?,
      note: map['note'] as String?,
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
      'pass': pass,
      'bCode': bCode,
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // --- Utility Methods ---

  // 4. Method to create MSocial from a JSON string
  factory MSocial.fromJson(String source) =>
      MSocial.fromMap(json.decode(source) as Map<String, dynamic>);

  // 5. Method to convert MSocial to a JSON string
  String toJson() => json.encode(toMap());

  // 6. toString() override for easy debugging/printing
  @override
  String toString() {
    return 'MSocial(id: $id title: $title, pass: $pass, bCode: $bCode, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // 7. copyWith() for creating a new instance with optional changes
  MSocial copyWith({
    String? id,
    String? title,
    String? pass,
    String? bCode,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MSocial(
      id: id ?? this.id,
      title: title ?? this.title,
      pass: pass ?? this.pass,
      bCode: bCode ?? this.bCode,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

