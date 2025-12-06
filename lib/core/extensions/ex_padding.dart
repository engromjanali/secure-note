import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

/// 📏 gapY / gapX
/// Shorthand widgets for vertical (`gapY`) and horizontal (`gapX`) spacing.
/// 🪄 Makes layout code cleaner.
/// 🔲 PaddingExtension on Widget
/// Adds handy padding extensions directly on any widget.
/// Includes:
/// - `pAll` → Padding on all sides
/// - `pH`, `pT`, `pB`, `pL`, `pR` → Padding individually
/// - `paddingExceptBottom` → Custom shortcut for specific cases
/// - `pTB`, `pLR` → Vertical and horizontal paddings
/// - `pDivider`→  A simple horizontal line used to divide sections in UI.

Widget gapY(double pt) => SizedBox(height: pt.h);
Widget gapX(double pt) => SizedBox(width: pt.w);

extension PaddingExtension on Widget {
  Widget pAll({double? value}) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: value?.w ?? PTheme.paddingX,
      vertical: value?.h ?? PTheme.paddingY,
    ),
    child: this,
  );
  Widget pH({double? value}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value?.w ?? PTheme.spaceX),
    child: this,
  );
  Widget pV({double? value}) => Padding(
    padding: EdgeInsets.symmetric(vertical: value?.h ?? PTheme.spaceX),
    child: this,
  );
  Widget pT({double? value}) => Padding(
    padding: EdgeInsets.only(top: value?.h ?? PTheme.spaceY),
    child: this,
  );
  Widget pB({double? value}) => Padding(
    padding: EdgeInsets.only(bottom: value?.h ?? PTheme.spaceX),
    child: this,
  );
  Widget pL({double? value}) => Padding(
    padding: EdgeInsets.only(left: value?.w ?? PTheme.spaceX),
    child: this,
  );
  Widget get paddingExceptBottom => Padding(
    padding: EdgeInsets.only(
      top: PTheme.paddingY,
      right: PTheme.paddingX,
      left: PTheme.paddingX,
    ),
    child: this,
  );
  Widget pR({double? value}) => Padding(
    padding: EdgeInsets.only(right: value?.w ?? PTheme.spaceX),
    child: this,
  );
  Widget pDivider({Color? color}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      this,
      Divider(
        height: 1.h,
        color: color ?? Theme.of(NavigationService.currentContext).dividerColor,
      ),
    ],
  );
}
