import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 📦 WContainer
/// A flexible, tappable container with customizable padding, border, color, and shape.
/// 💡 Ideal for wrapping content in a visually styled and optionally clickable box.
/// 🎯 Supports rectangular and circular shapes with optional border customization.
class WContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final Function()? onTap;
  final Color? borderColor;
  final double? verticalPadding, horizontalPadding, borderRadius;
  final BoxShape? boxShape;
  final List<BoxShadow>? boxShadow;
  final bool borderInDark;
  const WContainer({
    super.key,
    this.child,
    this.color,
    this.width,
    this.height,
    this.onTap,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderColor,
    this.borderRadius,
    this.boxShape,
    this.boxShadow,
    this.borderInDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? PTheme.paddingY,
          horizontal: horizontalPadding ?? PTheme.paddingX,
        ),
        decoration: BoxDecoration(
          color: color ?? context.fillColor,
          shape: boxShape ?? BoxShape.rectangle,
          boxShadow: context.theme.brightness == Brightness.dark
              ? null
              : boxShadow,
          border: context.theme.brightness == Brightness.dark && !borderInDark
              ? null
              : Border.all(
                  color:
                      borderColor ??
                      context
                          .theme
                          .inputDecorationTheme
                          .border!
                          .borderSide
                          .color,
                  width: 1.w,
                  // strokeAlign: BorderSide.strokeAlignOutside,
                ),

          borderRadius: boxShape == null
              ? BorderRadius.circular(borderRadius ?? PTheme.borderRadius)
              : null,
        ),
        child: child,
      ),
    );
  }
}
