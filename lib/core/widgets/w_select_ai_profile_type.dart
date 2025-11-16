import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:daily_info/core/widgets/w_pop_button.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ImageType { single, couple }

Future<ImageType?> showProfileTypeDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: true, // tap outside to close
    barrierColor: Colors.black.withOpacity(0.4), // dark overlay
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        backgroundColor: context.backgroundColor, // for custom Stack look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PTheme.borderRadius),
            border: Border.all(color: context.primaryTextColor ?? Colors.white),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PTheme.borderRadius),
            child: SizedBox(
              height: 642.h,
              width: 398.w,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox.expand(
                                child: Image.asset(
                                  Assets.images.good.a1.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox.expand(
                                child: Image.asset(
                                  Assets.images.good.a1.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Choose Your Profile Type",
                                  style: context.textTheme?.titleLarge,
                                ),
                                gapY(20),
                                Text(
                                  "Create a Single profile for yourself or a Couple profile with a partner!",
                                  style: context.textTheme?.titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ).pAll(),
                            Spacer(),

                            Column(
                              children: [
                                WCElevatedButton(
                                  ontap: () {
                                    Navigation.pop(data: ImageType.couple);
                                  },
                                  label: "Couple",
                                  margin: EdgeInsets.zero,
                                ).pB(value: 20),
                                WCElevatedButton(
                                  backgroundColor: context.cardColor,
                                  foregroundColor: Colors.white,
                                  ontap: () {
                                    Navigation.pop(data: ImageType.single);
                                  },
                                  label: "Single",
                                  margin: EdgeInsets.zero,
                                ),
                              ],
                            ).pAll(value: 5),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// close button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: WPButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
