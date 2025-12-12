class MProfile {
  String? id;
  String? name;
  String? email;
  String? image;
  String? sessionKey;
  DateTime? createdAt;
  DateTime? updatedAt;

  MProfile({
    this.id,
    this.name,
    this.email,
    this.image,
    this.sessionKey,
    this.createdAt,
    this.updatedAt,
  });

  factory MProfile.fromJson(Map<String, dynamic> json) => MProfile(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    sessionKey: json["sessionKey"],
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
    "sessionKey": sessionKey,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
