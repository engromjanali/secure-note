import 'package:another_flushbar/flushbar.dart';
import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_bottom_nav_button.dart';
import 'package:daily_info/core/widgets/w_pop_button.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WPurchese extends StatefulWidget {
  const WPurchese({super.key});

  @override
  State<WPurchese> createState() => _PurcheseScreenState();
}

class _PurcheseScreenState extends State<WPurchese> {
  int selectedPlain = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Text("Restore Purchase", style: context.textTheme?.bodyMedium),
        ],
        leading: WPButton(
          onTap: () {
            Navigation.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.ratingIcon.path,
              height: 170.w,
              width: 170.w,
            ),
            Text(
              "Get Full Access.",
              style: context.textTheme?.headlineSmall,
              textAlign: TextAlign.center,
            ).pV(value: 20),
            Column(
              children: [
                WProPlain(
                  onTap: () {
                    setState(() {
                      selectedPlain = 1;
                    });
                  },
                  title: "7-Day Full Access",
                  subTitle: "Then BDT 1,400/week",
                  amount: 950,
                  isSelected: selectedPlain == 1,
                ).pB(value: 20),
                WProPlain(
                  onTap: () {
                    setState(() {
                      selectedPlain = 2;
                    });
                  },
                  title: "Yearly Access",
                  amount: 5100,
                  isSelected: selectedPlain == 2,
                  offerText: 'SAVE 94%',
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WItemTile(icon: Icons.image, label: "Ultra Realistic HD"),
                    _WItemTile(icon: Icons.lock, label: "Unlock Ai Photos"),
                    _WItemTile(
                      icon: Icons.person,
                      label: "Create One Ai Profile",
                    ),
                    _WItemTile(icon: Icons.key, label: "Access to All Style"),
                  ],
                ),
                Spacer(),
              ],
            ).pV(value: 50),

            WBottomNavButton(
              label: "Purchase Now",
              ontap: () {
                showSnackBar("Thank you for having with us!");
              },
            ).pB(value: 17),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Auto-renews at Bdt 1400/week. No Commitment.\nCancel anytime.",
                style: context.textTheme?.bodyMedium,
                textAlign: TextAlign.center,
              ).pB(value: 20),
            ),
          ],
        ).pAll(),
      ),
    );
  }
}

class _WItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WItemTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }
}

class WProPlain extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String? subTitle;
  final int amount;
  final bool isSelected;
  final String? offerText;
  const WProPlain({
    super.key,
    required this.onTap,
    required this.title,
    this.subTitle,
    required this.amount,
    required this.isSelected,
    this.offerText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PTheme.borderRadius),
              gradient: isSelected
                  ? LinearGradient(colors: [Colors.blue, Colors.pinkAccent])
                  : null,
              color: context.secondaryTextColor,
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(210),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    size: 25.sp,
                    color: isSelected ? Colors.white : Colors.grey,
                  ).pR(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textTheme?.titleSmall),
                        if (!isNull(subTitle))
                          Text(
                            subTitle ?? PDefaultValues.noName,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "BDT $amount",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isNull(offerText))
            Positioned(
              right: 30.w,
              top: -10.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: context.primaryTextColor,
                  borderRadius: BorderRadius.circular(PTheme.borderRadius),
                ),
                child: Text(
                  offerText ?? PDefaultValues.noName,
                  style: context.textTheme?.titleSmall?.copyWith(
                    color: context.backgroundColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
