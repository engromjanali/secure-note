import 'dart:async';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/local_auth_services.dart';
import 'package:secure_note/features/stopwatch/controller/c_stopwatch.dart';
import 'package:secure_note/features/stopwatch/data/model/m_stopwatch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';

class SStopwatch extends StatefulWidget {
  const SStopwatch({super.key});
  @override
  State<SStopwatch> createState() => _SStopwatchState();
}

class _SStopwatchState extends State<SStopwatch> {
  final CStopwatch cStopwatch = PowerVault.put(CStopwatch());
  Timer? timer;
  FixedExtentScrollController listWheelController =
      FixedExtentScrollController();
  int selectedIndex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBackFunction(() async {
      await cStopwatch.initializeFromSharedPreferences();
      await Future.delayed(
        Duration(milliseconds: 100),
      ); //after adding a event it's take few mili/micro moment to emit then bloc response setstate/changeState
      if (cStopwatch.mStopwatch.isRunning && isNull(timer)) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    if (timer?.isActive ?? false) {
      _stopTimer();
      return;
    }
    timer = Timer.periodic(Duration(milliseconds: 100), (val) {
      MStopwatch mStopwatch = cStopwatch.mStopwatch;
      DateTime currentTime = DateTime.now();
      cStopwatch.increment(
        MStopwatch(
          isRunning: true,
          duration:
              // Duration.zero,
              mStopwatch.duration +
              currentTime.difference(mStopwatch.startTime ?? currentTime),
          lapList: mStopwatch.lapList,
          startTime: currentTime,
        ),
      );
    });
  }

  void _stopTimer() {
    MStopwatch mStopwatch = cStopwatch.mStopwatch;
    cStopwatch.increment(
      MStopwatch(
        isRunning: false,
        duration:
            mStopwatch.duration +
            DateTime.now().difference(mStopwatch.startTime ?? DateTime.now()),
        lapList: mStopwatch.lapList,
      ),
    );
    timer?.cancel();
  }

  void restStopwatch() {
    cStopwatch.increment(
      MStopwatch(isRunning: false, duration: Duration.zero, lapList: []),
    );
    timer?.cancel();
  }

  void addLap() {
    MStopwatch mStopwatch = cStopwatch.mStopwatch;
    if (!mStopwatch.isRunning) return;
    DateTime currentTime = DateTime.now();

    List<Duration> list = [];
    list.addAll(mStopwatch.lapList);
    list.add(mStopwatch.duration);
    mStopwatch.lapList = list;
    mStopwatch.duration =
        mStopwatch.duration +
        DateTime.now().difference(mStopwatch.startTime ?? DateTime.now());
    mStopwatch.startTime = currentTime;

    // cbloc.add(IncrementEvent(mStopwatch: mStopwatch));
    listWheelController.jumpToItem(mStopwatch.lapList.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stopwatch")),
      body: PowerBuilder<CStopwatch>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox.square(
                  dimension: 190.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.button?.primary.withAlpha(50),
                      border: Border.all(
                        color: context.button?.primary ?? Colors.amber,
                        width: 10.w,
                      ),
                    ),
                    child: PowerSelector<CStopwatch>(
                      selector: () => controller.mStopwatch.duration,
                      builder: (controller) {
                        printer(controller.mStopwatch.duration);
                        Duration currentCountTime =
                            controller.mStopwatch.duration;
            
                        return Center(
                          child: Text(
                            currentCountTime.toString().split(".").first +
                                ":" +
                                currentCountTime
                                    .toString()
                                    .split(".")
                                    .last
                                    .substring(0, 2),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      },
                    ),
                  ),
                ).pV(value: 50),
            
                // list while
                PowerSelector<CStopwatch>(
                  selector: () {
                    // selector compare with object reference not value.
                    // printer("ss${state.mStopwatch.lapList.hashCode}");
                    return controller.mStopwatch.lapList;
                  },
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (context, setLocalState) {
                        // debugPrint("ss listwheel rebuilded $lapList");
                        return SizedBox(
                          child: ClipRRect(
                            child: Align(
                              alignment: Alignment.topCenter,
                              heightFactor: 0.6, // show only top half
                              child: SizedBox(
                                height: 400,
                                child: ListWheelScrollView.useDelegate(
                                  controller: listWheelController,
                                  physics: FixedExtentScrollPhysics(),
                                  itemExtent: 30,
            
                                  onSelectedItemChanged: (value) {
                                    setLocalState(() {
                                      selectedIndex = value;
                                    });
                                  },
                                  dragStartBehavior: DragStartBehavior.down,
                                  //       initialIndex: cBloc.state.mStopwatch.lapList.isEmpty
                                  // ? 0
                                  // : cBloc.state.mStopwatch.lapList.length - 1,
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount:
                                        controller.mStopwatch.lapList.length,
                                    builder: (BuildContext context, int index) {
                                      String lap = controller
                                          .mStopwatch
                                          .lapList[index]
                                          .toString();
                                      return Center(
                                        child: Text(
                                          "#${index + 1} ${lap.split(".").first}:${lap.split(".").last.substring(0, 2)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                fontWeight: index == selectedIndex
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            
                // buttons tile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Rest
                    GestureDetector(
                      onTap: () {
                        restStopwatch();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.button?.primary,
                          borderRadius: BorderRadius.circular(
                            PTheme.borderRadius,
                          ),
                        ),
                        child: Text(
                          "Rest",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(color: Colors.white),
                        ).pH().pV(value: 5),
                      ),
                    ),
            
                    // play / pose
                    StatefulBuilder(
                      builder: (context, setLocalState) {
                        return GestureDetector(
                          onTap: () {
                            setLocalState(() {
                              _startTimer();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.button?.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              !controller.mStopwatch.isRunning
                                  ? Icons.play_arrow
                                  : Icons.stop,
                              color: Colors.white,
                              size: 25,
                            ).pAll(),
                          ),
                        );
                      },
                    ),
            
                    // lap
                    GestureDetector(
                      onTap: () async {
                        // addLap();
                        await LocalAuthServices().showBiometric();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.button?.primary,
                          borderRadius: BorderRadius.circular(
                            PTheme.borderRadius,
                          ),
                        ),
                        child: Text(
                          "Lap",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(color: Colors.white),
                        ).pH().pV(value: 5),
                      ),
                    ),
                  ],
                ).pV(),
              ],
            ),
          );
        },
      ),
    );
  }
}
