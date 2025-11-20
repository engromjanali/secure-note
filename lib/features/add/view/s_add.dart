import 'dart:async';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/extensions/ex_duration.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_keyboards.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_pick_date_time.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_button.dart';
import 'package:daily_info/core/widgets/w_card.dart';
import 'package:daily_info/core/widgets/w_container.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:daily_info/features/add/widgets/w_select_duration.dart';
import 'package:daily_info/features/note/data/model/m_note.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/datasource/demo_data.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:daily_info/features/task/data/repository/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class SAdd extends StatefulWidget {
  final bool onlyNote;
  final bool isEditPage;
  final MTask? mTask;
  final MNote? mNote;

  const SAdd({
    super.key,
    this.onlyNote = false,
    this.isEditPage = false,
    this.mTask,
    this.mNote,
  });

  @override
  State<SAdd> createState() => _SAddState();
}

class _SAddState extends State<SAdd> with RouteAware {
  PageRoute<dynamic>? _currentRoute;
  Timer? _timer;
  bool depandOnTime = true;
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  ValueNotifier<DateTime?> targetdDateTimeListener = ValueNotifier<DateTime?>(
    null,
  );
  ValueNotifier<Duration?> targetedDurationListener = ValueNotifier<Duration?>(
    null,
  );
  ValueNotifier<bool> isTaskListener = ValueNotifier<bool>(false);
  int selectedButton = 0;
  DateTime currentDateTime = DateTime.now();
  late DateTime startDateTime = currentDateTime;
  late DateTime endDateTime = currentDateTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController pointTController = TextEditingController();
  final double spacing = 20;

  @override
  void initState() {
    super.initState();
    isTaskListener.value = widget.onlyNote
        ? false
        : widget.isEditPage
        ? true // set here given value from parent.
        : false;
    startTimer();
  }

  void startTimer() {
    if (_timer?.isActive ?? false) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        // setState(() {});
        if (depandOnTime) {
          targetedDurationListener.value = targetdDateTimeListener.value
              ?.difference(DateTime.now());
        } else {
          targetdDateTimeListener.value = isNull(targetedDurationListener.value)
              ? null
              : DateTime.now().add(targetedDurationListener.value!);
        }
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
    PowerVault.delete<CTask>();
    super.dispose();
  }

  Future<void> submit() async {
    context.unFocus();
    if (fromKey.currentState?.validate() ?? false) {
      // normal datetime or DateTime.now() dose not contain utc it's only contain date and time.
      // final now = DateTime.now().toUtc();// way 1
      final now = DateTime.timestamp(); // way 2
      if (isTaskListener.value) {
        final cTask = PowerVault.put(CTask(TaskRepositoryImpl()));

        MTask payload = MTask(
          id: widget.mTask?.id ?? now.millisecondsSinceEpoch,
          title: titleController.text,
          points: titleController.text,
          details: titleController.text,
          createdAt: widget.mTask?.createdAt ?? now,
          endAt: targetdDateTimeListener.value,
          updatedAt: widget.isEditPage ? now : null,
          finishedAt: widget.mTask?.finishedAt,
        );

        if (widget.isEditPage) {
          cTask.updateTask(payload);
        } else {
          cTask.addTask(payload);
        }
      } else {
        MNote payload = MNote(
          id: widget.mNote?.id ?? DateTime.now().millisecondsSinceEpoch,
          title: titleController.text,
          points: titleController.text,
          details: titleController.text,
          createdAt: widget.mNote?.createdAt ?? now,
          updatedAt: widget.isEditPage ? now : null,
        );
        if (widget.isEditPage) {
          // cNote.updateTask(payload);
        } else {
          // cNote.addTask(payload);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: isTaskListener,
          builder: (context, isTask, child) {
            return Text(isTask ? "Add Task" : "Add Note");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            spacing: spacing,
            children: [
              Form(
                key: fromKey,
                child: Column(
                  spacing: spacing,
                  children: [
                    WTextField(label: "Points", controller: titleController),
                    WTextField(
                      label: "Points",
                      hintText: "Points-1\nPoints-2",
                      controller: pointTController,
                      minLines: 1,
                      maxLines: 6,
                    ),
                    Column(
                      children: [
                        WTextField.requiredField(
                          label: "Details",
                          controller: detailsController,
                          maxLines: 14,
                          minLines: 4,
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Invalid Details";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.newline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: isTaskListener,
                builder: (context, isTask, child) {
                  return Column(
                    children: [
                      // switch
                      WCard(
                        child: SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          title: Text(
                            "Add As Task",
                            style: context.textTheme?.labelMedium,
                          ),
                          value: isTask,
                          activeTrackColor: context.button?.primary,
                          onChanged: (value) {
                            // puse action if edit page or only note
                            if (widget.onlyNote || widget.isEditPage) return;
                            isTaskListener.value = value;
                          },
                        ),
                      ),
                      // date time
                      if (isTaskListener.value)
                        Column(
                          children: [
                            // time
                            ValueListenableBuilder(
                              valueListenable: targetdDateTimeListener,
                              builder: (context, value, child) {
                                printer(value);
                                return Column(
                                  children: [
                                    WDate(
                                      isDepamdedWidget: depandOnTime,
                                      dateTime: value,
                                      onTap: () async {
                                        targetdDateTimeListener.value =
                                            await pickeDateTime(
                                              context: context,
                                            ) ??
                                            targetdDateTimeListener.value;
                                        depandOnTime = true;
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).pB(),
                            // duration
                            ValueListenableBuilder(
                              valueListenable: targetedDurationListener,
                              builder: (context, value, child) {
                                printer(value);
                                return Column(
                                  children: [
                                    WDate(
                                      duration: value,
                                      isDuration: true,
                                      isDepamdedWidget: !depandOnTime,
                                      dateTime: targetdDateTimeListener.value,
                                      onTap: () async {
                                        targetedDurationListener.value =
                                            await WDialog.showCustom(
                                              children: [WSDuration()],
                                              context: context,
                                            ) ??
                                            targetedDurationListener.value;
                                        depandOnTime = false;
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),

              WPrimaryButton(text: "Submit", onTap: submit),
            ],
          ).pAll(),
        ),
      ),
    );
  }
}

class WDate extends StatelessWidget {
  final Function()? onTap;
  final bool isDuration;
  final DateTime? dateTime;
  final Duration? duration;
  final bool isDepamdedWidget;
  const WDate({
    super.key,
    this.isDuration = false,
    this.dateTime,
    this.onTap,
    required this.isDepamdedWidget,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isDuration)
            Text("Targetd Time", style: context.textTheme?.labelMedium).pB(),
          WContainer(
            verticalPadding: 5,
            horizontalPadding: 5,
            borderColor: context.button?.primary,
            color: context.theme.brightness == Brightness.dark
                ? PColors.secondaryFillColorDark
                : PColors.secondaryFillColorLight,
            borderInDark: true,
            child: Row(
              children: [
                Icon(
                  isDuration ? Icons.access_time_outlined : Icons.date_range,
                ),
                Text(
                  isDuration
                      ? (duration?.as_XX_Hours_XX_Minute_XX_Seconds ??
                            "Tap To Select Duration")
                      : dateTime?.format(
                              DateTimeFormattingExtension
                                  .formatDDMMMYYYY_I_HHMMA,
                            ) ??
                            "Tap To Select Date",

                  style: context.textTheme?.bodyLarge,
                  textAlign: TextAlign.center,
                ).pH().expd(),

                Icon(
                  Icons.push_pin_sharp,
                  color: isDepamdedWidget
                      ? context.primaryTextColor
                      : Colors.transparent,
                ),
              ],
            ).pAll(value: 0),
          ),
        ],
      ),
    );
  }
}
