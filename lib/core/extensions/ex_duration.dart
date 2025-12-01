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
extension DurationFormattingExtension on Duration {
  /// Remaining duration from now to this date
  /// 00 Hours 00 Minute 00 Seconds
  String get as_XX_Hours_XX_Minute_XX_Seconds {
    final h = inHours.toString().padLeft(2, '0');
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$h Hours $m Minute $s Seconds';
  }

  /// 00 : 00 : 00
  String get as_XX_XX_XX {
    final h = inHours.toString().padLeft(2, '0');
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$h : $m : $s';
  }

  /// 00 : 00 : 00 : 00
  String get as_XX_XX_XX_XXX {
    final h = inHours.toString().padLeft(2, '0');
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = inMilliseconds.remainder(1000).toString().padLeft(2, '0');
    return '$h : $m : $s : $ms';
  }

  String asPostFormate() {
    final seconds = inSeconds;
    final minutes = inMinutes;
    final hours = inHours;
    final days = inDays;

    if (seconds < 60) {
      return "just now";
    } else if (minutes < 60) {
      return "$minutes minute${minutes > 1 ? 's' : ''} ago";
    } else if (hours < 24) {
      return "$hours hour${hours > 1 ? 's' : ''} ago";
    } else if (days < 7) {
      return "$days day${days > 1 ? 's' : ''} ago";
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      return "$weeks week${weeks > 1 ? 's' : ''} ago";
    } else if (days < 365) {
      final months = (days / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else {
      final years = (days / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    }
  }
}

// extension StringToDateTimeExtension on String {
//   /// Parse a string to DateTime with a given format
//   DateTime toDateTime(String pattern) => DateFormat(pattern).parse(this);
// }

// extension NowDateHelper on DateTime {
//   /// Returns current date as formatted string
//   static String nowFormatted(String pattern) =>
//       DateFormat(pattern).format(DateTime.now());
// }
