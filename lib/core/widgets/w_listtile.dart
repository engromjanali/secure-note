import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WListTile extends StatelessWidget {
  final Color? leadingColor;
  final Color? fillColor;
  final String? title;
  final String? subTitle;
  final int index;
  final Function() onTap;
  const WListTile({
    super.key,
    this.leadingColor,
    this.fillColor,
    this.title,
    this.subTitle,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        _showPopupMenu(context, index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PTheme.borderRadius),
        child: Container(
          decoration: BoxDecoration(color: fillColor ?? context.cardColor),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  color: leadingColor ?? PColors.primaryButtonColorLight,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? PDefaultValues.noName,
                        style: context.textTheme?.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: PTheme.spaceX,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: context.textTheme?.titleSmall?.fontSize,
                          ),
                          Text(
                            subTitle ?? PDefaultValues.noName,
                            style: context.textTheme?.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ).pAll(),
                ),
              ],
            ),
          ),
        ),
      ).pV(value: 5),
    );
  }

  void _showPopupMenu(BuildContext context, int index) {
    final RenderBox renderBox =
        context.findRenderObject() as RenderBox; // get parent/tile's position.
    final Offset offset = renderBox.localToGlobal(
      Offset.zero,
    ); // get the parent/tile's top-left corner.

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + renderBox.size.width, // Position from right
        offset.dy + renderBox.size.height / 2, // Center vertically
        offset.dx + renderBox.size.width, // Right edge
        offset.dy + renderBox.size.height, // Bottom edge
      ),

      color: Colors.transparent,
      elevation: 0,

      items: [
        PopupMenuItem(
          value: 'edit',
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PTheme.borderRadius),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 20, color: Color(0xFF0088FF)),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ).pAll(),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'Duplicate',
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PTheme.borderRadius),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copy, size: 20, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ).pAll(),
            ),
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.symmetric(vertical: 2),
          value: 'Delete',
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(PTheme.borderRadius),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ).pAll(),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // done some opration here.
      }
    });
  }
}
