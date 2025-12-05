import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/extensions/ex_strings.dart';
import 'package:daily_info/core/widgets/w_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WListTile extends StatelessWidget {
  final Color? leadingColor;
  final Color? fillColor;
  final String? title;
  final String? subTitle;
  final TaskState taskState;
  final Function() onTap;
  final Function(ActionType) onAction;
  final bool isFromVault;
  final bool isSecretNote;
  const WListTile({
    super.key,
    this.leadingColor,
    this.fillColor,
    this.title,
    this.subTitle,
    required this.taskState,
    required this.onTap,
    required this.onAction,
    this.isFromVault = false,
    this.isSecretNote = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        _showPopupMenu(
          context,
          isFromVault: isFromVault,
          isSecretNote: isSecretNote,
        );
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
                        (title ?? "").toTitleCase.showDVIE,
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

  void _showPopupMenu(
    BuildContext context, {
    required bool isFromVault,
    required bool isSecretNote,
  }) {
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
          onTap: () {
            onAction(ActionType.edit);
          },
          value: 'edit',
          padding: EdgeInsets.symmetric(vertical: 2),
          child: WContainer(
            verticalPadding: 10,
            borderInDark: true,
            child: Center(
              child: Row(
                spacing: PTheme.spaceX,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 20.w, color: Color(0xFF0088FF)),
                  Text('Edit', textAlign: TextAlign.center).expd(),
                ],
              ),
            ),
          ),
        ),
        if (taskState == TaskState.note && !isFromVault)
          PopupMenuItem(
            onTap: () {
              onAction(ActionType.keepInVault);
            },
            value: 'Keep In Vault',
            padding: EdgeInsets.symmetric(vertical: 2),
            child: WContainer(
              verticalPadding: 10,
              // horizontalPadding: 0,
              borderInDark: true,
              child: Center(
                child: Row(
                  spacing: PTheme.spaceX,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.move_down, size: 20.w, color: Colors.green),
                    Text('Keep In Vault', textAlign: TextAlign.center).expd(),
                  ],
                ),
              ),
            ),
          ),
        if (isFromVault && isSecretNote)
          PopupMenuItem(
            onTap: () {
              onAction(ActionType.removeFromVault);
            },
            value: 'Remove From Vault',
            padding: EdgeInsets.symmetric(vertical: 2),
            child: WContainer(
              verticalPadding: 10,
              borderInDark: true,
              child: Center(
                child: Row(
                  spacing: PTheme.spaceX,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.move_down, size: 20.w, color: Colors.green),
                    Text('Put Back', textAlign: TextAlign.center).expd(),
                  ],
                ),
              ),
            ),
          ),
        PopupMenuItem(
          onTap: () {
            onAction(ActionType.delete);
          },
          padding: EdgeInsets.symmetric(vertical: 2),
          value: 'Delete',
          child: WContainer(
            verticalPadding: 10,
            color: Colors.red,
            // borderInDark: true,
            child: Center(
              child: Row(
                spacing: PTheme.spaceX,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, size: 20.w, color: Colors.black),
                  Text('Delete', textAlign: TextAlign.center).expd(),
                ],
              ),
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
