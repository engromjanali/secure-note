import 'package:flutter/foundation.dart';

/// 🌍 ENV
/// Environment configuration class to toggle between
/// development and production settings based on `kDebugMode`.
/// 🔁 Automatically switches base URLs accordingly.
class ENV {
  final bool isLive = !kDebugMode;
  late String baseUrl = isLive ? "https://api.cloudinary.com" : "https://api.cloudinary.com";
}
