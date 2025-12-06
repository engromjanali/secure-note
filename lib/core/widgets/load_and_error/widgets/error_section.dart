import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/widgets/w_button.dart';
import 'package:secure_note/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const WError({super.key, this.message = "An error occurred", this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.logo.a404Error, height: 200.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.displaySmall,
          ),
          if (onRetry != null) ...[
            gapY(10),
            WPrimaryButton.border(
              width: PTheme.imageDefaultX,
              text: "Retry",
              onTap: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
