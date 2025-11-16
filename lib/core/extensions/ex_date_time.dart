import 'package:intl/intl.dart';

/// 📅 DateTimeFormattingExtension
/// Extends `DateTime` to format dates, get timestamps,
/// and calculate remaining days from now.
/// 🛠️ Utilities:
/// - `format()` 🧾
/// - `remainingDaysFromNow` 📆
/// - `timestamp` ⏱️
/// 🧵 StringToDateTimeExtension
/// Parse a string into a `DateTime` using a custom format.
/// Useful when working with server date strings or custom formats.
/// ⏰ NowDateHelper
/// Static helper to get current date formatted instantly.

extension DateTimeFormattingExtension on DateTime {
  static const String formatYYYYMMDD = 'yyyy-MM-dd';
  static const String formatDDMMMYYYY = 'dd MMM yyyy';
  static const String formatDDMMMYYYY_I_HHMMA = 'dd MMM yyyy | hh:mm a';

  /// Format this DateTime to a string
  String format(String pattern) => DateFormat(pattern).format(this);

  /// Remaining duration from now to this date
  String get remainingFormatedDuration {
    final now = DateTime.now();
    String hours = difference(now).inHours.toString().padLeft(2, '0');

    String minutes = (difference(now).inMinutes % 60).toString().padLeft(
      2,
      '0',
    );
    return '$hours Hours $minutes Minute $second Seconds';
  }

  /// Return timestamp (milliseconds since epoch)
  String get timestamp => millisecondsSinceEpoch.toString();
}

extension StringToDateTimeExtension on String {
  /// Parse a string to DateTime with a given format
  DateTime toDateTime(String pattern) => DateFormat(pattern).parse(this);
}

extension NowDateHelper on DateTime {
  /// Returns current date as formatted string
  static String nowFormatted(String pattern) =>
      DateFormat(pattern).format(DateTime.now());
}
