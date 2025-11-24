import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WPButton extends StatelessWidget {
  final Function() onTap;
  final double size;
  final bool isWButton;
  final bool isPopButton;

  const WPButton({super.key, required this.onTap, this.size = 40})
    : isWButton = false,
      isPopButton = true;
  const WPButton.remove({
    super.key,
    required this.onTap,
    this.size = 20,
    this.isWButton = true,
  }) : isPopButton = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        isWButton ? Assets.icons.close2.path : Assets.icons.close.path,
        height: size.w,
      ),
    ).pAll(value: 10);
  }
}
