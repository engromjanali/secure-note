import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/widgets/w_task_section.dart';
import 'package:daily_info/core/widgets/w_timer_task_section.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
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
  void initState() {
    super.initState();

    // for (int i = 0; i < 55; i++) {
    //   itemList.add((i, Random().nextInt(200) + 100));
    // }

    // 🔹 Listen to item positions (which items are visible)
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      // Print all visible indexes
      final visibleIndexes = positions.map((e) => e.index).toList()..sort();
      debugPrint("Visible indexes: $visibleIndexes");

      if (visibleIndexes.isNotEmpty) {
        int lastVisibleIndex = visibleIndexes.last;
        removeData(lastVisibleIndex: visibleIndexes.last);
        // loadData(lastVisibleIndex: lastVisibleIndex);
      }
    });
  }

  Future<void> removeData({required int lastVisibleIndex}) async {
    /// Note :
    /// when i call "jumpTo" it's automitically rebuild ScrollablePositionedList, for "scrollTo" to we must have to call setState.
    /// if we use "scrollTo" the duration has passed as argument, we should delay the same Diration to change (state flag)  otherwise we fatch an error,

    // // using scrollTo
    // if (lastVisibleIndex > 100 && !alreadyLoading) {
    //   debugPrint("removed few data");
    //   alreadyLoading = true;
    //   Duration duration = Duration(milliseconds: 200);
    //   itemList.removeRange(0, 80); // remove 80 item
    //   itemScrollController.scrollTo(
    //     index: lastVisibleIndex - 80,
    //     duration: duration,
    //     alignment: 1,
    //   );
    //   setState(() {
    //     // Get.snackbar("title", "message ${itemList.length}");
    //   });
    //   await Future.delayed(duration);
    //   alreadyLoading = false;
    // }

    // using "jumpTo"
    // if (lastVisibleIndex > 100 && !alreadyLoading) {
    //   debugPrint("removed few data");
    //   alreadyLoading = true;

    //   itemList.removeRange(0, 80); // remove 80 item
    //   itemScrollController.jumpTo(
    //     index: lastVisibleIndex - 80,
    //     alignment: 1,
    //   );
    //   alreadyLoading = false;
    // }
  }

  // Future<void> loadData({required int lastVisibleIndex}) async {
  //   if (lastVisibleIndex >= itemList.length - 10 && !alreadyLoading) {
  //     debugPrint("⚡ Near the end! Loading more...");
  //     alreadyLoading = true;

  //     int i = itemList.last.$1 + 1;
  //     int n = i + 10;
  //     for (; i < n; i++) { // adding 10 item every call
  //       itemList.add((i, Random().nextInt(200) + 100));
  //     }

  //     setState(() {}); // Update UI
  //     alreadyLoading = false;
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    // PowerVault.delete<CTask>();
    super.dispose();
  }

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
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.tune_rounded),
                ),
              ),
            ).pB(),

            (widget.taskState == TaskState.pending)
                ? WTimerTaskSection(
                    items: [
                      MTask(id: 2),
                      MTask(id: 2),
                      MTask(id: 2),
                      MTask(id: 2),
                      MTask(id: 2),
                    ],
                  )
                : WTaskSection(
                    items: [
                      MTask(id: 9),
                      MTask(id: 9),
                      MTask(id: 9),
                      MTask(id: 9),
                      MTask(id: 9),
                    ],
                    taskState: widget.taskState,
                  ),
          ],
        ).pAll(),
      ),
    );
  }
}
