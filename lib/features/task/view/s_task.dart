import 'dart:async';
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
import 'package:daily_info/features/note/view/s_view_note.dart';
import 'package:daily_info/features/task/view/s_view_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliver_tools/sliver_tools.dart';

class STask extends StatefulWidget {
  const STask({super.key});

  @override
  State<STask> createState() => _STaskState();
}

class _STaskState extends State<STask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task")),
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
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // todays task
                SliverToBoxAdapter(child: gapY(20)),
                WTimerTaskSectionSlivers(
                  leadingColor: PColors.pendingColor,
                  itemCount: 3,
                  title: 'Pending Task',
                  taskState: TaskState.pending,
                ),
                WTaskSection(
                  leadingColor: PColors.timeoutColor,
                  itemCount: 6,
                  title: 'Time-Out Task',
                  taskState: TaskState.timeOut,
                ),
                WTaskSection(
                  leadingColor: PColors.completedColor,
                  itemCount: 20,
                  title: 'Completed Task',
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

class WTaskSection extends StatelessWidget {
  final Color? leadingColor;
  final String? title;
  final int itemCount;
  final TaskState taskState;

  const WTaskSection({
    super.key,
    required this.title,
    required this.itemCount,
    this.leadingColor,
    required this.taskState,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 10.h),
      sliver: MultiSliver(
        children: [
          if (isNotNull(title))
            SliverToBoxAdapter(
              child: Row(
                spacing: PTheme.spaceX,
                children: [
                  Icon(
                    Icons.circle,
                    color: leadingColor,
                    size: context.textTheme?.titleSmall?.fontSize,
                  ),
                  Text(
                    title!,
                    style: context.textTheme?.titleSmall?.copyWith(
                      color: leadingColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ).pR().expd(),
                  Row(
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
                ],
              ),
            ),
          SliverList.builder(
            itemBuilder: (context, index) {
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
                  SViewNote().push();
                },
                index: index,
                title:
                    "Mobile App Reacharch Application has Created By Md Romjan Ali",
                subTitle: "$dateTime | $status",
                // status:""
              );
            },
            itemCount: itemCount,
          ),
        ],
      ),
    );
  }
}

/// Timer version of the section
class WTimerTaskSectionSlivers extends StatefulWidget {
  final Color? leadingColor;
  final String title;
  final int itemCount;
  final TaskState taskState;

  const WTimerTaskSectionSlivers({
    super.key,
    required this.title,
    required this.itemCount,
    this.leadingColor,
    required this.taskState,
  });

  @override
  State<WTimerTaskSectionSlivers> createState() =>
      _WTimerTaskSectionSliversState();
}

class _WTimerTaskSectionSliversState extends State<WTimerTaskSectionSlivers>
    with RouteAware {
  PageRoute<dynamic>? _currentRoute;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Current route খুঁজুন
    final route = ModalRoute.of(context);

    // যদি route PageRoute হয় এবং আগের route এর সাথে different হয়
    if (route is PageRoute && route != _currentRoute) {
      // পুরাতন route থেকে unsubscribe
      if (_currentRoute != null) {
        NavigationService.routeObserver.unsubscribe(this);
      }

      // নতুন route তে subscribe
      _currentRoute = route;
      NavigationService.routeObserver.subscribe(this, _currentRoute!);
    }
  }

  @override
  void didPushNext() {
    _timer?.cancel();

    print('FirstScreen: নতুন screen এ গেছি');
  }

  @override
  void didPopNext() {
    startTimer();
    print('FirstScreen: ফিরে এসেছি');
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_currentRoute != null) {
      NavigationService.routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WTaskSection(
      leadingColor: widget.leadingColor,
      itemCount: widget.itemCount,
      title: widget.title,
      taskState: widget.taskState,
    );
  }
}
