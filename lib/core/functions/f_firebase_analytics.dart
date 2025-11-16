import 'package:daily_info/core/functions/f_printer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton pattern
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Log screen view manually
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      infoPrint(
          'Analytics: Screen view logged - screenName: $screenName, screenClass: ${screenClass ?? screenName}');
    } catch (e) {
      infoPrint(
          'Analytics: Failed to log screen view - screenName: $screenName, error: $e');
    }
  }

  // Log custom event
  Future<void> logCustomEvent(
      String eventName, Map<String, Object>? parameters) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
      infoPrint(
          'Analytics: Custom event logged - eventName: $eventName, parameters: $parameters');
    } catch (e) {
      infoPrint(
          'Analytics: Failed to log custom event - eventName: $eventName, error: $e');
    }
  }

  // Set user property
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      infoPrint('Analytics: User property set - name: $name, value: $value');
    } catch (e) {
      infoPrint(
          'Analytics: Failed to set user property - name: $name, error: $e');
    }
  }
}
