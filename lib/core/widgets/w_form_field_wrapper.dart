import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🧾 WFormFieldWrapper
/// Wraps a form field with:
/// 🔹 Optional title label
/// 🔸 Required field asterisk (*)
/// ❗ Error message display
/// Useful for consistently styling form fields with proper labels and validation feedback.

class WFormFieldWrapper extends StatelessWidget {
  final String? title;
  final bool isRequired;
  final String? errorText;
  final Widget child;

  const WFormFieldWrapper({
    super.key,
    this.title,
    this.isRequired = false,
    this.errorText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme?.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            children: [
              Text(title!, style: labelStyle),
              if (isRequired)
                Text(
                  " *",
                  style: labelStyle?.copyWith(color: context.redColor),
                ),
            ],
          ).pB(value: 5),
        child,
        if (errorText != null)
          Text(
            "$title is $errorText",
            style: context.textTheme?.labelMedium?.copyWith(
              color: context.redColor,
              fontSize: 12.sp,
            ),
          ).pV(value: 3),
      ],
    );
  }
}
