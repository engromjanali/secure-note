class MProfile {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MProfile({
    this.id,
    this.name,
    this.email,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory MProfile.fromJson(Map<String, dynamic> json) => MProfile(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
