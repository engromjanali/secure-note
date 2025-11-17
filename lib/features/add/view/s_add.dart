import 'dart:async';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/extensions/ex_duration.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_keyboards.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_button.dart';
import 'package:daily_info/core/widgets/w_card.dart';
import 'package:daily_info/core/widgets/w_container.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:daily_info/features/add/widgets/w_select_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SAddTask extends StatefulWidget {
  const SAddTask({super.key});

  @override
  State<SAddTask> createState() => _SAddTaskState();
}

class _SAddTaskState extends State<SAddTask> with RouteAware {
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
  // ValueNotifier<bool> isTaskListener = ValueNotifier<bool>(false);
  int selectedButton = 0;
  bool isTask = true;
  DateTime currentDateTime = DateTime.now();
  late DateTime startDateTime = currentDateTime;
  late DateTime endDateTime = currentDateTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  final double spacing = 20;
  Future<DateTime?> getPickedDateTime({
    required BuildContext buildContext,
    DateTime? initialDateTime,
  }) async {
    DateTime? date = await _getPickedDate(context, initialDateTime);
    if (date == null) return null;
    TimeOfDay? timeOfDay = await _getPickedTime(context, initialDateTime);
    if (timeOfDay == null) return null;
    return date.add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
  }

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  Future<DateTime?> _getPickedDate(
    BuildContext context,
    DateTime? initialDateTime,
  ) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
      initialDate: initialDateTime ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    return date;
  }

  Future<void> submit() async {
    context.unFocus();
    fromKey.currentState?.validate();
  }

  Future<TimeOfDay?> _getPickedTime(
    BuildContext context,
    DateTime? dateTime,
  ) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.fromDateTime(dateTime ?? DateTime.now()),
    );
    return timeOfDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isTask ? "Add Task" : "Add Note")),
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
                    WTextField(label: "Title", controller: titleController),
                    SizedBox(
                      height: 400.h,
                      child: Column(
                        children: [
                          WTextField.requiredField(
                            label: "Details",
                            controller: detailsController,
                            maxLines: null,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Invalid Details";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.newline,
                            expands: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // switch
              WCard(
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    "Add As Task",
                    style: context.textTheme?.labelMedium,
                  ),
                  value: isTask,
                  onChanged: (value) {
                    isTask = value;
                    setState(() {});
                  },
                ),
              ),
              // date time
              if (isTask)
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
                                    await getPickedDateTime(
                                      buildContext: context,
                                    );
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
                                    );
                                depandOnTime = false;
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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
