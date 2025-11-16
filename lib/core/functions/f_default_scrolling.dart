import 'package:flutter/material.dart';

/// 🚫 Removes default Android overscroll glow
/// 🍏 Uses iOS-style bouncing scroll physics
/// 🧩 Apply globally in `MaterialApp` → `scrollBehavior: PScrollBehavior()`
class PScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // disables Android glow
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // or ClampingScrollPhysics
  }
}
