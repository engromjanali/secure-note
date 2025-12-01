import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/data/local/db_local.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:daily_info/core/widgets/w_listtile.dart';
import 'package:daily_info/features/add/view/s_add.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/datasource/task_datasource_impl.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:daily_info/features/task/data/repository/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class WDismisable extends StatelessWidget {
  final Color? leadingColor;
  final Color? fillColor;
  final String? title;
  final String? subTitle;
  final bool isFromVault;
  final TaskState taskState;
  final MTask mTask;
  final Function() onTap;
  final int index;
  final Function(ActionType) onAction;
  final Function(int) onDismissed;
  WDismisable({
    super.key,
    required this.taskState,
    required this.mTask,
    required this.onTap,
    required this.onAction,
    required this.index,
    this.title,
    this.fillColor,
    this.leadingColor,
    this.subTitle,
    required this.isFromVault,
    required this.onDismissed,
  });
  CTask cTask = PowerVault.put(CTask(TaskRepositoryImpl(TaskDataSourceImpl())));

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(mTask?.id ?? 0), // 🧠 Must be unique
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
          String message =
              "Do You Want To ${taskState == TaskState.completed
                  ? "Set As Pending"
                  : taskState == TaskState.pending
                  ? "Mark As Completed"
                  : taskState == TaskState.note && isFromVault
                  ? "Move To Genaral"
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
        onDismissed(mTask.id!);
        if (direction == DismissDirection.startToEnd) {
          if (taskState == TaskState.pending) {
            // move to completed
            Map<String, dynamic> data = mTask.toMap();
            data.update(
              DBHelper.finishedAt,
              (value) => DateTime.timestamp().toIso8601String(),
            );
            MTask payload = MTask.fromMap(data);
            printer(payload.toMap());
            cTask.updateTask(payload);
          } else if (taskState == TaskState.completed) {
            Map<String, dynamic> data = Map.from(mTask.toMap());
            data.remove(DBHelper.finishedAt);
            MTask payload = MTask.fromMap(data);
            printer(payload.toMap());
            cTask.updateTask(payload);
          }
        } else if (direction == DismissDirection.endToStart) {
          SAdd(
            isEditPage: true,
            onlyNote: taskState == TaskState.note,
            mTask: mTask,
          ).push();
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("item dismissed")));
      },
      background: taskState == TaskState.timeOut
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
                        : taskState == TaskState.note && isFromVault
                        ? "Move To Genaral"
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

      child: WListTile(
        leadingColor: leadingColor,
        fillColor: fillColor,
        title: title,
        subTitle: subTitle,
        taskState: taskState,
        onTap: onTap,
        index: index,
        onAction: onAction,
      ),
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
