import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/extensions/ex_duration.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_call_back.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dismisable.dart';
import 'package:daily_info/core/widgets/w_listtile.dart';
import 'package:daily_info/features/note/view/s_details.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class WTaskSection extends StatefulWidget {
  Color? leadingColor;
  final String? title;
  final bool isTask;
  final List<MTask>? items;
  final Function()? onTap;
  final TaskState taskState;
  final bool asSliver;
  final Function()? loadNext;
  final Function()? loadPrevious;
  final Function((int, int))? removeCache;

  WTaskSection({
    super.key,
    this.title,
    this.isTask = true,
    this.items,
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
            : taskState == TaskState.completed
            ? PColors.completedColor
            : null);
  }

  @override
  State<WTaskSection> createState() => _WTaskSectionState();
}

class _WTaskSectionState extends State<WTaskSection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  double lastPosition = 0;
  ScrollDirection currentScrollDirection = ScrollDirection.reverse;
  CTask cTask = PowerVault.find<CTask>();
  List<MTask> items = [];

  @override
  void initState() {
    super.initState();
    callBackFunction(() {
      if (!widget.asSliver) {
        printer("value-");
        cTask.fetchSpacificItem(payload: MQuery(taskState: widget.taskState));
        initScrolling();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initScrolling() {
    // List<MTask>
    // items = widget.taskState == TaskState.pending
    //     ? cTask.pendingList
    //     : widget.taskState == TaskState.timeOut
    //     ? cTask.timeOutList
    //     : widget.taskState == TaskState.completed
    //     ? cTask.completedList
    //     : cTask.noteList;

    // 🔹 Listen to item positions (which items are visible)
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      // Print all visible indexes
      // debugPrint("Visible indexes: ${positions.map((e) => e.index)}");

      if (positions.isNotEmpty) {
        final firstVisibleItem = positions.reduce(
          (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
        );
        final lastVisibleItem = positions.reduce(
          (a, b) => a.itemTrailingEdge > b.itemTrailingEdge ? a : b,
        );
        final int lastVisibleIndex = lastVisibleItem.index;
        final int firstVisibleIndex = firstVisibleItem.index;
        if (lastVisibleIndex >= 200 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !cTask.isLoadingMore) {
          // remove from top,
          removeData(lastVIndex: lastVisibleIndex);
        }
        if (firstVisibleIndex <= 10 &&
            items.length > 200 &&
            currentScrollDirection == ScrollDirection.forward &&
            !cTask.isLoadingMore) {
          // remove from end,
          removeData(lastVIndex: lastVisibleIndex, removeFormTop: false);
        }
        if (firstVisibleIndex <= 10 &&
            currentScrollDirection == ScrollDirection.forward &&
            !cTask.isLoadingMore &&
            cTask.hasMorePrev) {
          // add previous
          printer("call for load previous");
          cTask.fetchSpacificItem(
            payload: MQuery(taskState: widget.taskState, isLoadNext: false),
          );
        }
        if (lastVisibleIndex >= items.length - 11 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !cTask.isLoadingMore &&
            cTask.hasMoreNext) {
          // load next
          printer("call for load next");
          cTask.fetchSpacificItem(payload: MQuery(taskState: widget.taskState));
        }
        // set scroll direction.
        double currentPosition = firstVisibleItem.itemLeadingEdge;
        if (currentPosition > lastPosition) {
          print("⬇️ Scrolling Forward");
          currentScrollDirection = ScrollDirection.forward;
        } else if (currentPosition < lastPosition) {
          print("⬆️ Scrolling Reverse");
          currentScrollDirection = ScrollDirection.reverse;
        }
        lastPosition = currentPosition;
      }
    });
  }

  Future<void> removeData({
    // int? firstVIndex,
    int? lastVIndex,
    bool removeFormTop = true,
    int pageCount = 5,
  }) async {
    // using "jumpTo"
    if (!cTask.isLoadingMore) {
      cTask.isLoadingMore = true;
      if (removeFormTop) {
        printer("remove data from top");
        items.removeRange(0, (pageCount * cTask.limit));
        cTask.update();
        itemScrollController.jumpTo(
          index: lastVIndex! - (pageCount * cTask.limit),
          alignment: 1,
        );
        cTask.firstPage += pageCount;
      } else {
        printer("remove data from bottom/end");
        items.removeRange(
          items.length - (pageCount * cTask.limit),
          items.length,
        );
        cTask.update();
        cTask.lastPage -= pageCount;
        cTask.hasMoreNext = true;
      }
      cTask.isLoadingMore = false;
      cTask.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PowerBuilder<CTask>(
      builder: (cTask) {
        // printer("length length ${items.length}");
        // printer("length first ${cTask.firstPage}");
        // printer("length last ${cTask.lastPage}");
        // printer("${items[0].endAt}");
        // cTask.isLoadingMore = false;

        items = items = widget.taskState == TaskState.pending
            ? cTask.pendingList
            : widget.taskState == TaskState.timeOut
            ? cTask.timeOutList
            : widget.taskState == TaskState.completed
            ? cTask.completedList
            : cTask.noteList;
        return widget.asSliver
            ? SliverPadding(
                padding: EdgeInsets.only(bottom: 10.h),
                sliver: MultiSliver(
                  children: [
                    if (isNotNull(widget.title) && items.isNotEmpty)
                      SliverToBoxAdapter(child: header(context)),
                    SliverList.builder(
                      itemBuilder: builder,
                      itemCount: items!.length,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (isNotNull(widget.title) && items.isNotEmpty)
                    header(context),
                  ScrollablePositionedList.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: builder,
                    itemScrollController: itemScrollController,
                    scrollOffsetController: scrollOffsetController,
                    itemPositionsListener: itemPositionsListener,
                    scrollOffsetListener: scrollOffsetListener,
                  ).expd(),
                ],
              ).pB().expd();
      },
    );
  }

  Widget builder(context, index) {
    String dateTime =
        items[index].createdAt?.format(
          DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
        ) ??
        items[index].finishedAt?.toString() ??
        PDefaultValues.noName;

    String status = widget.taskState == TaskState.pending
        ? items[index].endAt?.difference(DateTime.timestamp()).as_XX_XX_XX ??
              PDefaultValues.noName
        : (widget.taskState == TaskState.completed)
        ? "Completed"
        : "Time-Out";
    return items.length == index
        ? CircularProgressIndicator()
        : WDismisable(
            isFromVault: false,
            onDismissed: (id) {
              setState(() {
                items.removeWhere((MTask mTask) => mTask.id == id);
              });
            },
            taskState: widget.taskState,
            leadingColor: widget.leadingColor,
            onTap: () {
              SDetails(isTask: true, mtask: items[index]).push();
            },

            onAction: (ActionType actionType) {
              if (actionType == ActionType.edit) {
              } else if (actionType == ActionType.delete) {
                cTask.deleteTask(items[index].id!);
              }
            },
            index: items[index].id ?? 0,
            title: items[index].title,
            subTitle: "$dateTime | $status",
            mTask: items[index],
            // status:""
          );
  }

  Widget header(BuildContext context) => Row(
    spacing: PTheme.spaceX,
    children: [
      Icon(
        Icons.circle,
        color: widget.leadingColor,
        size: context.textTheme?.titleSmall?.fontSize,
      ),
      Text(
        widget.title!,
        style: context.textTheme?.titleSmall?.copyWith(
          color: widget.leadingColor,
        ),
        overflow: TextOverflow.ellipsis,
      ).pR().expd(),
      GestureDetector(
        onTap: widget.onTap,
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
