import 'dart:io';

import '/core/functions/f_is_null.dart';

class MAuth {
  String? name;
  String? email;
  String? password;
  UserType userTypeEnum;
  String? platform;
  String? provider;
  String? providerId;
  String? image;

  MAuth({
    this.name,
    this.email,
    this.password,
    this.userTypeEnum = UserType.user,
    this.platform,
    this.provider,
    this.providerId,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "userType": getUserType(userTypeEnum),
      "platform": Platform.isIOS ? "ios" : "android",
      if (!isNull(name)) "name": name,
      if (!isNull(password)) "password": password,
      if (!isNull(provider)) "provider": provider,
      if (!isNull(providerId)) "providerId": providerId,
      if (!isNull(image)) "image": image,
    };
  }
}

enum UserType { user, tester }

String getUserType(UserType userType) {
  switch (userType) {
    case UserType.tester:
      return "tester";
    case UserType.user:
      return "customer";
  }
}
