import 'dart:ui';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_loader.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/w_button.dart';
import 'package:secure_note/core/widgets/w_close_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 📦 Utility class to display reusable bottom sheets
class WBottomSheet {
  /// 📄 Shows a blurred custom modal popup
  static Future<dynamic> showCustomBottomSheet({
    BuildContext? context,
    String? title,
    Widget? widgets,
    bool dynamic = true,
    bool barrierDismissible = true,
  }) async {
    final ctx = context ?? NavigationService.currentContext;
    return await showCupertinoModalPopup(
      barrierDismissible: barrierDismissible,
      context: ctx,
      builder: (BuildContext modalContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          height: dynamic ? null : ScreenUtil().screenHeight * 0.6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ctx.theme.brightness == Brightness.dark
                ? ctx.cardColor
                : ctx.indicatorColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
          ),
          child: Material(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
            color: ctx.theme.brightness == Brightness.dark
                ? ctx.cardColor
                : ctx.indicatorColor,
            child: dynamic
                ? Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷 Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title ?? "N/A",
                                style: modalContext.textTheme?.titleMedium
                                    ?.copyWith(fontSize: 20.sp),
                              ),
                              const WClose(),
                            ],
                          ),
                          gapY(10),
                          if (widgets != null) widgets,
                        ],
                      ).pAll(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title ?? "N/A",
                            style: modalContext.textTheme?.titleLarge?.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          const WClose(),
                        ],
                      ),
                      gapY(10),
                      if (widgets != null) widgets,
                    ],
                  ).pAll(),
          ),
        ),
      ),
    );
  }

  /// ⚠️ Displays a warning confirmation before executing an action
  static Future<void> showWarningSheetBeforeAction({
    BuildContext? context,
    VoidCallback? onYes,
  }) {
    return showCustomBottomSheet(
      context: context,
      title: "⚠️ Warning!",
      dynamic: true,
      widgets: Column(
        children: [
          const Text("Do you want to proceed with this action?"),
          gapY(10),
          Row(
            children: [
              // ❌ Cancel button
              Expanded(
                child: WPrimaryButton.border(
                  text: "No",
                  onTap: () {
                    hideOverlay();
                  },
                ),
              ),
              gapX(5),
              // ✅ Confirm button
              Expanded(
                child: WPrimaryButton(
                  text: "Yes",
                  onTap: () {
                    hideOverlay();
                    Future.delayed(const Duration(milliseconds: 50), () {
                      onYes?.call();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
