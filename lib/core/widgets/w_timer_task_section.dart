import 'dart:async';
import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_task_section.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:flutter/material.dart';

/// Timer version of the section
class WTimerTaskSection extends StatefulWidget {
  final Color? leadingColor;
  final String? title;
  final List<MTask>? items;
  final Function()? onTap;
  final TaskState taskState;
  final bool asSliver;

  const WTimerTaskSection({
    super.key,
    this.title,
    this.items,
    this.leadingColor,
    this.onTap,
    this.taskState = TaskState.pending,
    this.asSliver = false,
  });

  @override
  State<WTimerTaskSection> createState() => _WTimerTaskSectionSliversState();
}

class _WTimerTaskSectionSliversState extends State<WTimerTaskSection>
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
      onTap: widget.onTap,
      leadingColor: widget.leadingColor,
      items: widget.items,
      title: widget.title,
      taskState: widget.taskState,
      asSliver: widget.asSliver,
    );
  }
}
