import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:flutter/material.dart';

class WHaveAccount extends StatelessWidget {
  final String label;
  final String actionText;
  final Function() onTap;
  const WHaveAccount({
    super.key,
    required this.label,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PTheme.spaceX,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: context.textTheme?.titleSmall),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // removes inner padding
            minimumSize: Size.zero, // removes min size constraint
            tapTargetSize: MaterialTapTargetSize
                .shrinkWrap, // smallest possible touch area
          ),
          child: Text(
            actionText,
            style: context.textTheme?.titleSmall?.copyWith(
              color: context.button!.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
