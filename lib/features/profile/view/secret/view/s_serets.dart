import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:daily_info/features/add/view/s_add.dart';
import 'package:daily_info/features/profile/view/secret/view/s_add_sencitive_note.dart';
import 'package:daily_info/features/profile/view/secret/widgets/w_select_note_type.dart';
import 'package:daily_info/features/task/view/s_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SSerets extends StatefulWidget {
  const SSerets({super.key});

  @override
  State<SSerets> createState() => _SSeretsState();
}

class _SSeretsState extends State<SSerets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secret Note")),
      floatingActionButton: GestureDetector(
        onTap: () async {
          NoteType res = await WDialog.showCustom(
            context: context,
            children: [WSNoteType()],
          );
          if (isNotNull(res)) {
            if (res == NoteType.reguler) {
              SAdd(onlyNote: true).push();
            } else {
              SASNote(viewOnly: true).push();
            }
          }
        },
        child: Container(
          height: 50.r,
          width: 50.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: PColors.primaryButtonColorDark,
          ),
          child: Icon(Icons.add_task_rounded, size: 30.r),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_sharp),
              hintText: "Search Task Here",
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.tune_rounded),
              ),
            ),
          ).pB(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // todays task
                SliverToBoxAdapter(child: gapY(20)),
                WTaskSection(
                  leadingColor: PColors.pendingColor,
                  itemCount: 6,
                  title: 'Reguler Note',
                  taskState: TaskState.timeOut,
                ),
                WTaskSection(
                  leadingColor: PColors.completedColor,
                  itemCount: 20,
                  title: 'Sencetive Note',
                  taskState: TaskState.completed,
                ),
              ],
            ),
          ),
        ],
      ).pAll(),
    );
  }
}
