import 'package:flutter/material.dart';

/// 🎨 PColors
/// A central place for managing all theme-related colors in the project.
/// 🔧 Includes:
/// - Primary, secondary, and app bar colors
/// - Background, border, and corporate branding colors
/// - Uses `withValues` for dynamic alpha adjustments
class PColors {
  // Core Colors
  static const primaryColorLight = Color(0XFFFFFFFF);
  static const primaryColorDark = Color(0xFF141416);

  // app bar
  static const appBarColorLight = Color(0XFFFFFFFF);
  static const appBarColorDark = Color(0xFF000000);
  // nav bar
  static const nevColorLight = Color(0XFFFFFFFF);
  static const nevColorDark = Color(0xFF000000);
  // card color
  static const cardColorLight = Color(0x0D000000);
  static const cardColorDark = Color(0xFF121214);

  // primary button color
  static const primaryButtonColorLight = Color(0xFF0088FF);
  static const primaryButtonColorDark = Color(0xFF0088FF);
  // primary button color
  static const secondaryButtonColorLight = Color.fromARGB(255, 20, 189, 223);
  static const secondaryButtonColorDark = Color.fromARGB(255, 54, 143, 221);

  //fill color
  static const fillColorLight = Color(0xFFFFFFFF);
  // static const fillColorDark = Color(0xFF000000);
  static const fillColorDark = Color(0xFF121214);
  static const secondaryFillColorLight = Color(0x1a0088FF);
  static const secondaryFillColorDark = Color(0xFF121214);

  // Backgrounds
  static const backGroundColorLight = Color(0xFFF0F0F0);
  static const backGroundColorDark = Color(0xFF000000);

  // Borders
  static final borderColorLight = Color(0xFFFFFFFF);
  static final borderColorDark = Color(0xFF2B2B2B);

  // Divider Colors/
  static final dividerColorLight = Color(0xFFFFFFFF);
  static final dividerColorDark = Color(0xFF171717);

  // Text Colors
  static const primayTextColorLight = Color(0XFF000000);
  static const primayTextColorDark = Color(0XFFFFFFFF);
  static const secondaryTextColorLight = Color(0XFF000000);
  static const secondaryTextColorDark = Color(0XFFFFFFFF);
  static const additionalTextColorLight = Colors.green;
  static const additionalTextColorDark = Colors.green;

  // image filter color
  static Gradient imageFG = LinearGradient(
    begin: Alignment.bottomCenter, // start at bottom
    end: Alignment.topCenter,
    stops: [0.05, 0.1, 0.2, 1],
    // transform: GradientRotation(4),
    colors: [
      Colors.black, // bottom color
      Colors.black.withAlpha(50), // bottom color
      Colors.transparent, // top color
      Colors.transparent, // top color
    ],
  );
  static var proLinearGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF01FD8C), Color(0xFF2FDFFF)],
  );

  // indicator color,
  static const pendingColor = Color(0xFFA8986B);
  static const timeoutColor = Colors.red;
  static const completedColor = Color(0xff004d4d);

  //
}
