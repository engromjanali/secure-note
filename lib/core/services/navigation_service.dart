import 'package:secure_note/core/functions/f_firebase_analytics.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  static final currentContext = key.currentContext!;
}

extension Navigation on Widget {
  // Function to push a new screen with a Slide transition and log screen view.
  Future push({BuildContext? context, String? screenName}) async {
    // Log screen view to Firebase Analytics
    await AnalyticsService().logScreenView(
      screenName: screenName ?? runtimeType.toString(),
      screenClass: runtimeType.toString(),
    );

    return await Navigator.push(
      context ?? NavigationService.key.currentContext!,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  // Function to push a new screen, replacing the current one, with a Scale transition.
  Future pushReplacement({BuildContext? context, String? screenName}) {
    // Log screen view to Firebase Analytics
    AnalyticsService().logScreenView(
      screenName: screenName ?? runtimeType.toString(),
      screenClass: runtimeType.toString(),
    );

    return Navigator.pushReplacement(
      context ?? NavigationService.key.currentContext!,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(scale: animation, child: child);
        },
      ),
    );
  }

  // Function to push a new screen and remove all previous screens.
  Future pushAndRemoveUntil({BuildContext? context, String? screenName}) {
    // Log screen view to Firebase Analytics
    AnalyticsService().logScreenView(
      screenName: screenName ?? runtimeType.toString(),
      screenClass: runtimeType.toString(),
    );

    return Navigator.pushAndRemoveUntil(
      context ?? NavigationService.key.currentContext!,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(scale: animation, child: child);
        },
      ),
      (route) => false,
    );
  }

  // Function to pop the current screen and optionally log an event.
  static void pop({BuildContext? context, String? screenName, dynamic data}) {
    // Optionally log a custom event for pop action
    if (screenName != null) {
      AnalyticsService().logCustomEvent('screen_popped', {
        'screen_name': screenName,
      });
    }

    return Navigator.pop(context ?? NavigationService.key.currentContext!, data);
  }
}

