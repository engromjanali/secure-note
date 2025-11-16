// 🔠 StringCasingExtension
// Powerful string utilities for formatting, validation, and transformation.
// ✨ Features:
// - `toCapitalized`, `toTitleCase` 📛
// - `isValidEmail`, `isValidPhone`, `isNumeric` ✅
// - `removeSpaces` 🧹
// - `initials` 🧑‍💼

extension StringCasingExtension on String {
  String get toCapitalized => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized).join(' ');
  bool get isValidEmail => RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}").hasMatch(this);
  bool get isValidPhone => RegExp(r"^\+?[0-9]{7,15}$").hasMatch(this);
  bool get isValidUrl => RegExp(r'^(https?:\/\/)?' // optional scheme
      r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain
      r'(\/[^\s]*)?$').hasMatch(this);
  bool get isNumeric => num.tryParse(this) != null;
  bool get isValidInt =>  RegExp(r'^[+-]?[0-9]+$').hasMatch(this);
  String get removeSpaces => replaceAll(' ', '');
  String get initials => split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase();
}
