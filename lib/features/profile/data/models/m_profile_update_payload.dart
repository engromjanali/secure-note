import 'dart:io';

class MProfileUpdatePayload {
  int? id;
  String? name;
  String? email;
  String? password;
  String? image;

  MProfileUpdatePayload({
    this.id,
    this.name,
    this.email,
    this.password,
    this.image,
  });

  factory MProfileUpdatePayload.fromJson(Map<String, dynamic> json) {
    return MProfileUpdatePayload(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'platform': Platform.isIOS ? "ios" : "android",
    };
  }
}
