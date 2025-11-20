import 'package:flutter/foundation.dart';

/// 🛠️ printer(value) — Debug-only logging
/// 🐞 errorPrint(msg) — Logs with 🐞 emoji for quick spotting
/// 📌 infoPrint(msg) — Logs info wrapped in 📌 emoji

void printer(dynamic value) {
  if (kDebugMode) {
    print("📌 $value 📌");
  }
}

void errorPrint(dynamic value) {
  printer("🐞 $value 🐛");
}

void infoPrint(dynamic value) {
  printer("📌 $value 📌");
}
