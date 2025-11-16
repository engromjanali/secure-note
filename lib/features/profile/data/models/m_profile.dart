class MProfile {
  final int? id;
  final String? name;
  final String? email;
  final dynamic googleId;
  final dynamic image;
  final String? userType;
  final String? platform; //:"android"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MProfile({
    this.id,
    this.name,
    this.email,
    this.googleId,
    this.image,
    this.userType,
    this.platform,
    this.createdAt,
    this.updatedAt,
  });

  factory MProfile.fromJson(Map<String, dynamic> json) => MProfile(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        googleId: json["googleId"],
        image: json["image"],
        userType: json["userType"],
        platform: json["platform"],
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
        "googleId": googleId,
        "image": image,
        "userType": userType,
        "platform" : platform,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
