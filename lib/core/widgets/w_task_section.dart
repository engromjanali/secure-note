import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/extensions/ex_duration.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_listtile.dart';
import 'package:daily_info/features/note/view/s_details.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class WTaskSection extends StatelessWidget {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  ScrollController scrollController = ScrollController();

  Color? leadingColor;
  final String? title;
  final List<MTask> items;
  final Function()? onTap;
  final TaskState taskState;
  final bool asSliver;
  final Function()? loadNext;
  final Function()? loadPrevious;
  final Function((int, int))? removeCache;

  WTaskSection({
    super.key,
    this.title,
    required this.items,
    this.leadingColor,
    this.onTap,
    required this.taskState,
    this.asSliver = false,
    this.loadNext,
    this.loadPrevious,
    this.removeCache,
  }) {
    leadingColor =
        leadingColor ??
        ((taskState == TaskState.pending)
            ? PColors.pendingColor
            : taskState == TaskState.timeOut
            ? PColors.timeoutColor
            : PColors.completedColor);
  }

  void init() {
    // 🔹 Listen to item positions (which items are visible)
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      // Print all visible indexes
      final visibleIndexes = positions.map((e) => e.index).toList()..sort();
      debugPrint("Visible indexes: $visibleIndexes");

      if (visibleIndexes.isNotEmpty) {
        int lastVisibleIndex = visibleIndexes.last;
        int firstVisibleIndex = visibleIndexes.first;
        if (lastVisibleIndex >= 200 ) {
          // remove from top,
        }
        if (firstVisibleIndex <= 10) {
          // remove from end,
        }
        if (firstVisibleIndex <= 10) {
          // add previous
        }
        if (lastVisibleIndex >= items.length - 10 - 1) {
          // load next
        }
        // removeData(lastVisibleIndex: visibleIndexes.last);
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
    //   itemScrollController.jumpTo(index: lastVisibleIndex - 80, alignment: 1);
    //   alreadyLoading = false;
    // }
  }

  // Future<void> loadData({required int lastVisibleIndex}) async {
  //   if (lastVisibleIndex >= itemList.length - 10 && !alreadyLoading) {
  //     debugPrint("⚡ Near the end! Loading more...");
  //     alreadyLoading = true;

  //     int i = itemList.last.$1 + 1;
  //     int n = i + 10;
  //     for (; i < n; i++) {
  //       // adding 10 item every call
  //       itemList.add((i, Random().nextInt(200) + 100));
  //     }

  //     setState(() {}); // Update UI
  //     alreadyLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return asSliver
        ? SliverPadding(
            padding: EdgeInsets.only(bottom: 10.h),
            sliver: MultiSliver(
              children: [
                if (isNotNull(title))
                  SliverToBoxAdapter(child: header(context)),
                SliverList.builder(
                  itemBuilder: builder,
                  itemCount: items.length,
                ),
              ],
            ),
          )
        : Column(
            children: [
              if (isNotNull(title)) header(context),
              ScrollablePositionedList.builder(
                itemCount: items.length,
                itemBuilder: builder,
                
                itemScrollController: itemScrollController,
                scrollOffsetController: scrollOffsetController,
                itemPositionsListener: itemPositionsListener,
                scrollOffsetListener: scrollOffsetListener,
              ).expd(),
            ],
          ).pB().expd();
  }

  Widget builder(context, index) {
    String dateTime = DateTime.now().format(
      DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
    );
    String status = taskState == TaskState.pending
        ? (Duration(hours: 1, minutes: 1, seconds: 60) -
                  Duration(seconds: DateTime.now().second))
              .as_XX_XX_XX
        : taskState == TaskState.completed
        ? "Completed"
        : "Time-Out";
    return WListTile(
      leadingColor: leadingColor,
      onTap: () {
        SDetails(isTask: true).push();
      },
      index: index,
      title: "Mobile App Reacharch Application has Created By Md Romjan Ali",
      subTitle: "$dateTime | $status",
      // status:""
    );
  }

  Widget header(BuildContext context) => Row(
    spacing: PTheme.spaceX,
    children: [
      Icon(
        Icons.circle,
        color: leadingColor,
        size: context.textTheme?.titleSmall?.fontSize,
      ),
      Text(
        title!,
        style: context.textTheme?.titleSmall?.copyWith(color: leadingColor),
        overflow: TextOverflow.ellipsis,
      ).pR().expd(),
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              "See All",
              style: context.textTheme?.titleSmall?.copyWith(
                color: context.button?.primary,
              ),
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    ],
  );
}
