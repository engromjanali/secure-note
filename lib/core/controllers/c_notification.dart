import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:secure_note/core/controllers/c_base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../functions/f_printer.dart';

/// 🔔 Handles setup and display of local & push notifications
class CNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// 🔥 Android-specific high-priority channel configuration
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  CNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // 🛠 Initialization settings for Android & iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 📡 Create the notification channel for Android
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // 🔔 Set display options for foreground messages (iOS)
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// 📲 Fetches the FCM token from Firebase Messaging
  Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /// ⬆️ Update FCM token to user profile (TODO)
  Future<void> updateFCMTokenToUserProfile() async {
    try {
      final String? token = await getFCMToken();
      if (token != null) {
        // TODO: Implement logic to update FCM token to user profile
      }
    } catch (e, s) {
      CBase().setException(
        error: e,
        stackTrace: s,
        setExceptionOnly: true,
        showSnackbar: false,
      );
    }
  }

  /// 🔐 Request notification permission on iOS
  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);

      // 🧾 Log permission status
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          infoPrint('✅ User granted permission');
          break;
        case AuthorizationStatus.provisional:
          infoPrint('⚠️ User granted provisional permission');
          break;
        default:
          infoPrint('❌ User declined permission');
      }
    }
  }

  /// 🚀 Initializes listeners for Firebase push notifications
  Future<void> initNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        RemoteNotification notification = message.notification!;
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printer("📬 App opened via message: ${message.data}");
    });
  }

  /// 📢 Displays a local notification (e.g., foreground messages)
  Future<void> showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(android: androidDetails, iOS: iOSDetails),
      payload: json.encode(message.data),
    );
  }
}

/// 🛠 Background handler for FCM messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle FCM message in background
}
