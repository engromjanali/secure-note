import 'package:flutter/material.dart';

Future<DateTime?> pickeDateTime({
  required BuildContext context,
  DateTime? initialDateTime,
}) async {
  DateTime? date = await pickDate(context, initialDateTime);
  if (date == null) return null;
  TimeOfDay? timeOfDay = await pickTime(context, initialDateTime);
  if (timeOfDay == null) return null;
  return date.add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
}

Future<DateTime?> pickDate(
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

Future<TimeOfDay?> pickTime(
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
