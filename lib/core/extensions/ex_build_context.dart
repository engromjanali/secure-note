import 'package:flutter/material.dart';

/// 🧵 ThemeExtension on BuildContext
/// A rich set of helpers to easily access `ThemeData`, text styles,
/// screen dimensions, and focus control from any widget context.
/// 🧩 Includes:
/// - TextStyles, card color, fillColor
/// - Width & height of screen
/// 🪄 Greatly improves UI building and readability!

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  Color get cardColor => Theme.of(this).cardColor;
  Color get redColor => Colors.red;
  ColorScheme? get button => Theme.of(this).buttonTheme.colorScheme;
  Color? get fillColor => Theme.of(this).inputDecorationTheme.fillColor;
  Color? get indicatorColor => Theme.of(this).tabBarTheme.indicatorColor;
  // text color
  Color? get secondaryTextColor => Theme.of(this).textTheme.bodyLarge!.color;
  Color? get primaryTextColor => Theme.of(this).primaryColor;
  // background color
  Color? get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  // Text theme
  TextTheme? get textTheme => Theme.of(this).textTheme;
}
