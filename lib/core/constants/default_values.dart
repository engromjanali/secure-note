// ⚙️ PDefaultValues
// Holds default constant values used across the app.
// 🧰 Includes:
// - Default texts for missing data (name, image, fee)
// - File type validation list
// - Character limits for inputs
// - Phone number length, DOB limits, etc.

import 'package:flutter/widgets.dart';

class PDefaultValues {
  static const String encryption = "encryption";
  static const String noFee = "N/A";
  static const String noName = "N/A";
  static const int phoneNumberLength = 11;
  static const int textMaxLength = 100;
  static const int textAreaMaxLength = 1000;
  static const List<String> allowedFileTypes = ['jpg', 'pdf', 'png'];
  static const int minDOBDate = 1900;
  static const int passwordMinLength = 8;

  /// limit[ limit ]
  static const int limit = 20;
  static const privacyUrlLink =
      "https://docs.google.com/document/d/1jSM2v4XdcQFqzF8N1E68LY5S-pMeeVv3_GvkGRtgC6Y/edit?usp=sharing";
  static const termsConditionUrl =
      "https://docs.google.com/document/d/1JUKmCdzRqxBZ5RMtYaAQZU-NzSZ17WU4cY3tzHSl5Tw/edit?usp=sharing";
  static const instagramLink = "https://www.instagram.com/engromjanali";
  static const tiktokLink = "https://www.tiktok.com/404?fromUrl=/engromjanali";
  static const facebookLink =
      "https://www.tiktok.com/404?fromUrl=/engromjanali";
  static const mailLink = "engromjanali@gmail.com";
  static const linkedIn = "https://www.linkedin.com/in/engromjanali/";
  static const profileImage =
      "https://res.cloudinary.com/dskavcx9z/image/upload/v1762793373/IMG_3963_1_fouocn.png";
}
