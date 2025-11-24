import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/controllers/c_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CTheme extends CBase {
  int currentIndex = 0;
  late List<ThemeData> themeList = [_lightTheme, _darkTheme];
  ThemeData get currentTheme => themeList[currentIndex];

  void updateTheme({int? index}) async {
    currentIndex = index ?? (currentIndex == 0 ? 1 : 0);
    debugPrint(currentIndex.toString());
    update();
    // SharedPrefService.instance.setInt(PKeys.themeIndex, index);
  }

  late final ThemeData _lightTheme = ThemeData(
    // ▶️ Core Configuration
    brightness: Brightness.light,
    useMaterial3: true,
    cardColor: PColors.cardColorLight,
    primaryColor: PColors.primayTextColorLight,
    unselectedWidgetColor: PColors.secondaryTextColorLight,
    scaffoldBackgroundColor: PColors.backGroundColorLight,
    splashColor: const Color(0xFF6F23FD).withValues(alpha: 0.1),
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    canvasColor: Colors.black.withValues(alpha: 0.05),
    dividerColor: PColors.dividerColorLight,

    tabBarTheme: TabBarThemeData(indicatorColor: Colors.black),

    // ▶️ AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: PColors.appBarColorLight,
      iconTheme: const IconThemeData(color: PColors.primayTextColorLight),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: PColors.primayTextColorLight,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: PColors.nevColorLight,
    ),

    // ▶️ Drawer Theme
    drawerTheme: const DrawerThemeData(scrimColor: Colors.white),

    // ▶️ Text Theme
    textTheme: TextTheme(
      // headline for large text
      headlineLarge: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 30.sp,
        fontWeight: FontWeight.w900,
      ),
      headlineSmall: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
      ),
      //title for mid large
      titleLarge: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
      //title for subtitle
      bodyLarge: TextStyle(
        color: PColors.secondaryTextColorLight,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: PColors.secondaryTextColorLight,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: PColors.secondaryTextColorLight,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        color: PColors.primayTextColorLight,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ▶️ Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PColors.fillColorLight,
      hintStyle: TextStyle(
        color: PColors.hintTextColorLight,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
    ),

    // ▶️ Button Theme
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: PColors.primaryButtonColorLight,
        seedColor: const Color(0xFF002E5B),
        secondary: PColors.secondaryButtonColorLight,
        tertiary: Colors.white,
        shadow: Colors.grey.withValues(alpha: 0.1),
      ),
      highlightColor: Colors.white,
    ),

    // ▶️ Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll<BorderSide>(BorderSide(width: 1.0)),
        backgroundColor: const WidgetStatePropertyAll<Color?>(
          Colors.transparent,
        ),
      ),
    ),
  );

  late final ThemeData _darkTheme = ThemeData(
    // ▶️ Core Configuration
    brightness: Brightness.dark,
    useMaterial3: true,
    cardColor: PColors.cardColorDark,
    primaryColor: PColors.primayTextColorDark,
    unselectedWidgetColor: PColors.secondaryTextColorDark,
    scaffoldBackgroundColor: PColors.backGroundColorDark,
    splashColor: const Color(0xFF6F23FD).withValues(alpha: 0.1),
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    canvasColor: Colors.black.withValues(alpha: 0.05),
    dividerColor: PColors.dividerColorDark,

    tabBarTheme: TabBarThemeData(indicatorColor: Colors.black),

    // ▶️ AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: PColors.appBarColorDark,
      iconTheme: const IconThemeData(color: PColors.primayTextColorDark),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: PColors.primayTextColorDark,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: PColors.nevColorDark,
    ),

    // ▶️ Drawer Theme
    drawerTheme: const DrawerThemeData(scrimColor: Colors.white),

    // ▶️ Text Theme
    textTheme: TextTheme(
      // headline for large text
      headlineLarge: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
      ),
      //title for mid large
      titleLarge: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
      //title for subtitle
      bodyLarge: TextStyle(
        color: PColors.secondaryTextColorDark,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: PColors.secondaryTextColorDark,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: PColors.secondaryTextColorDark,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        color: PColors.primayTextColorDark,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ▶️ Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PColors.fillColorDark,
      hintStyle: TextStyle(
        color: PColors.hintTextColorDark,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Color(0xFF8391A1), width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(PTheme.borderRadius)),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
    ),

    // ▶️ Button Theme
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: PColors.primaryButtonColorDark,
        seedColor: const Color(0xFF002E5B),
        secondary: PColors.secondaryButtonColorDark,
        tertiary: Colors.white,
        shadow: Colors.grey.withValues(alpha: 0.1),
      ),
      highlightColor: Colors.white,
    ),

    // ▶️ Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll<BorderSide>(BorderSide(width: 1.0)),
        backgroundColor: const WidgetStatePropertyAll<Color?>(
          Colors.transparent,
        ),
      ),
    ),
  );
}
