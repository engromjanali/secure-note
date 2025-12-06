import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/extensions/ex_duration.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/extensions/ex_strings.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_timer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:flutter/material.dart';

class SDetails extends StatefulWidget {
  final bool isTask;
  final bool? isFromVault;
  final MTask? mtask;
  final MSecret? mSecret;
  const SDetails({
    super.key,
    this.isTask = false,
    this.mtask,
    this.isFromVault,
    this.mSecret,
  });
  @override
  State<SDetails> createState() => _SDetailsState();
}

class _SDetailsState extends State<SDetails> {
  final ValueNotifier<Duration?> targetedDurationListener =
      ValueNotifier<Duration?>(null);

  @override
  void initState() {
    super.initState();
    callBackFunction(() async {
      if (widget.isFromVault ?? false) {
        //
      } else {
        TimerService().listen(() {
          if (mounted &&
              isNotNull(widget.mtask?.endAt) &&
              widget.mtask!.endAt!.difference(DateTime.timestamp()) >
                  Duration.zero) {
            targetedDurationListener.value = widget.mtask?.endAt?.difference(
              DateTime.timestamp(),
            );
          } else {
            TimerService().stop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    TimerService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTask ? "Task" : "Note"),
        actions: [
          IconButton(
            onPressed: () {
              // SAdd(isEditPage: true).pushReplacement();
              SAdd(
                isEditPage: true,
                onlyNote: isNull(widget.mtask?.endAt) ? true : false,
                mTask: widget.mtask,
                mSecret: widget.mSecret,
                isSecret: widget.isFromVault ?? false,
              ).pushReplacement();
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.mtask?.title ?? (widget.mSecret?.title ?? ""))
                        .toTitleCase
                        .showDVIE,
                    style: context.textTheme?.titleSmall,
                  ),
                ],
              ).pDivider().pB(),
              // points section
              Text(
                isNull(widget.mtask?.points ?? widget.mSecret?.title)
                    ? ""
                    : (widget.mtask?.points ?? (widget.mSecret!.points!))
                          .replaceAll("\n", "\n◉ ")
                          .replaceFirst("", "◉ "),
                textAlign: TextAlign.justify,
                style: context.textTheme?.bodyLarge,
              ).pB(value: 20),
              // details section
              Text(
                widget.mtask?.details ??
                    (widget.mSecret?.details ?? PDefaultValues.noName),
                textAlign: TextAlign.justify,
                style: context.textTheme?.bodyLarge,
              ).pB(),
              // info section
              SizedBox.shrink().pDivider(),
              // remaining time
              if (widget.isTask &&
                  isNull(widget.mtask?.finishedAt) &&
                  isNotNull(widget.mtask?.endAt))
                ValueListenableBuilder(
                  valueListenable: targetedDurationListener,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reamining : ${value?.as_XX_Hours_XX_Minute_XX_Seconds ?? "Time Out"}",
                          style: context.textTheme?.bodyMedium?.copyWith(
                            color: isNull(value) ? PColors.timeoutColor : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              showDateAsFormated(
                "Finished At",
                widget.mtask?.finishedAt,
                color: PColors.completedColor,
                context: context,
              ),
              showDateAsFormated(
                "End At",
                widget.mtask?.endAt,
                context: context,
              ),
              showDateAsFormated(
                "Updated At",
                widget.mtask?.updatedAt ?? widget.mSecret?.updatedAt,
                context: context,
              ),
              showDateAsFormated(
                "Created At",
                widget.mtask?.createdAt ?? widget.mSecret?.createdAt,
                doNotShowIfNull: false,
                context: context,
              ),
            ],
          ).pAll(),
        ),
      ),
    );
  }
}

Widget showDateAsFormated(
  String leading,
  DateTime? dateTime, {
  bool doNotShowIfNull = true,
  Color? color,
  required BuildContext context,
}) {
  if (doNotShowIfNull) {
    return isNotNull(dateTime)
        ? Text(
            "$leading: ${dateTime?.format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA)}",
            style: context.textTheme?.bodyMedium?.copyWith(color: color),
          )
        : SizedBox.shrink();
  } else {
    return Text(
      "$leading: ${dateTime?.format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA)}",
      style: context.textTheme?.bodyMedium?.copyWith(color: color),
    );
  }
}
