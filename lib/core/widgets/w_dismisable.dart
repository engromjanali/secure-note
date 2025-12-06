import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/data/local/db_local.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/core/widgets/w_image_source_dialog.dart';
import 'package:secure_note/core/widgets/w_listtile.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:secure_note/features/task/controller/c_task.dart';
import 'package:secure_note/features/task/data/datasource/task_datasource_impl.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:secure_note/features/task/data/repository/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class WDismisable extends StatelessWidget {
  final Color? leadingColor;
  final Color? fillColor;
  final String? title;
  final String? subTitle;
  final bool isFromVault;
  final TaskState taskState;
  final MTask? mTask;
  final MSecret? mSecret;
  final Function() onTap;
  // final int index;
  final Function(ActionType) onAction;
  final bool isSecretNote;
  final bool withDismissable;
  WDismisable({
    super.key,
    required this.taskState,
    this.mTask,
    this.mSecret,
    required this.onTap,
    required this.onAction,
    this.title,
    this.fillColor,
    this.leadingColor,
    this.subTitle,
    required this.isFromVault,
    this.isSecretNote = false,
    this.withDismissable = true,
  });

  @override
  Widget build(BuildContext context) {
    return withDismissable
        ? Dismissible(
            key: ValueKey(
              isFromVault ? (mSecret?.id) : (mTask?.id),
            ), // 🧠 Must be unique
            direction: DismissDirection.horizontal, // both sides allowed
            resizeDuration: const Duration(
              milliseconds: 300,
            ), // shrink animation speed
            movementDuration: const Duration(
              milliseconds: 200,
            ), // swipe animation speed
            confirmDismiss: (direction) async {
              // 🧭 Before dismiss — decide what to do
              if (direction == DismissDirection.startToEnd) {
                // Left to right
                if (taskState == TaskState.timeOut ||
                    (isFromVault && !isSecretNote)) {
                  // prevent if it's timeout or secret passkey
                  return false;
                }
                String message =
                    "Do You Want To ${taskState == TaskState.completed
                        ? "Set As Pending"
                        : taskState == TaskState.pending
                        ? "Mark As Completed"
                        : (isSecretNote && isFromVault)
                        ? "remove From Valut"
                        : "Keep In Vault"}";
                final confirm = await _confirmDialog(context, message);
                return confirm;
              } else if (direction == DismissDirection.endToStart) {
                // Right to left
                return true;
              }
              return false; // prevent dismissable
            },
            onDismissed: (direction) {
              // 🗑 Called after confirmed dismiss
              if (direction == DismissDirection.startToEnd) {
                if (taskState == TaskState.pending) {
                  // // move to completed
                  onAction(ActionType.markAsComplete);
                } else if (taskState == TaskState.completed) {
                  // set as pending
                  onAction(ActionType.setAsPending);
                } else if (isFromVault && isSecretNote) {
                  // move to genaral
                  onAction(ActionType.removeFromVault);
                } else if (taskState == TaskState.note) {
                  // keep in valut
                  onAction(ActionType.keepInVault);
                }
              } else if (direction == DismissDirection.endToStart) {
                // edit
                onAction(ActionType.edit);
              }
            },
            background:
                taskState == TaskState.timeOut || (isFromVault && !isSecretNote)
                ? Container(color: PColors.timeoutColor)
                : Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: PTheme.spaceX,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.move_down, color: Colors.white),
                        Text(
                          taskState == TaskState.completed
                              ? "Set As Pending"
                              : taskState == TaskState.pending
                              ? "Mark As Completed"
                              : (isSecretNote && isFromVault)
                              ? "Remove From Valut"
                              : "Keep In Vault",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
            secondaryBackground: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: PTheme.spaceX,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(),
                  Text(
                    "EDIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.white),
                ],
              ),
            ),
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.4,
              DismissDirection.endToStart: 0.4,
            },
            crossAxisEndOffset: 0.2, // pushes dismissed item up/down at end

            child: child(),
          )
        : child();
  }

  Widget child() {
    return WListTile(
      leadingColor: leadingColor,
      fillColor: fillColor,
      title: title,
      subTitle: subTitle,
      taskState: taskState,
      onTap: onTap,
      onAction: onAction,
      isFromVault: isFromVault,
      isSecretNote: isSecretNote,
    );
  }

  Future<bool?> _confirmDialog(BuildContext context, String message) async {
    return await WDialog.showCustom(
      context: context,
      children: [
        Text(message, style: context.textTheme?.titleSmall),
        gapY(40),
        WCElevatedButton(
          ontap: () {
            Navigation.pop(data: true);
          },
          label: "yes",
          backgroundColor: context.primaryTextColor,
          foregroundColor: context.backgroundColor,
          margin: EdgeInsets.all(10),
        ),
        WCElevatedButton(
          ontap: () {
            Navigation.pop(data: false);
          },
          label: "No",
          backgroundColor: context.backgroundColor,
          foregroundColor: context.primaryTextColor,
          margin: EdgeInsets.only(bottom: 30, top: 10, left: 10, right: 10),
        ),
      ],
    );
  }
}
