import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/widgets/w_task_section.dart';
import 'package:secure_note/core/widgets/w_timer_task_section.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SSeeAll extends StatefulWidget {
  final TaskState taskState;
  const SSeeAll({super.key, this.taskState = TaskState.pending});

  @override
  State<SSeeAll> createState() => _SSeeAllState();
}

class _SSeeAllState extends State<SSeeAll> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskState == TaskState.pending
              ? "Pending Task"
              : widget.taskState == TaskState.timeOut
              ? "Time-Out"
              : "Completed",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_sharp),
                hintText: "Search Task Here",
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.tune_rounded),
                ),
              ),
            ).pB(),

            (widget.taskState == TaskState.pending)
                ? WTimerTaskSection(taskState: widget.taskState)
                : WTaskSection(taskState: widget.taskState),
          ],
        ).pAll(),
      ),
    );
  }
}
