
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

/// 🗓️⏰ WDateTimePicker
/// A read-only field that launches a date or date+time picker when tapped.
/// 🔢 Format can be customized (defaults to DD/MM/YYYY)
/// 📅 `dateOnly` determines if time selection is shown
/// ✅ Optional validation, hint text, and min/max limits
/// 🛠️ Use `WDateTimePicker.required` to mark the field as mandatory.
class WDateTimePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool dateOnly;
  final String dtFormat;
  final DateTime? minDT;
  final DateTime? maxDT;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final bool isRequired;

  const WDateTimePicker({
    super.key,
    required this.controller,
    required this.label,
    this.dtFormat = DateTimeFormattingExtension.formatYYYYMMDD,
    this.minDT,
    this.maxDT,
    this.hintText,
    this.dateOnly = true,
    this.validator,
    this.onDateTimeChanged,
  }) : isRequired = false;

  const WDateTimePicker.required({
    super.key,
    required this.controller,
    required this.label,
    this.dtFormat = DateTimeFormattingExtension.formatYYYYMMDD,
    this.minDT,
    this.maxDT,
    this.hintText,
    this.dateOnly = true,
    this.validator,
    this.onDateTimeChanged,
  }) : isRequired = true;

  void _openPicker(BuildContext context) {
    dateOnly
        ? DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: minDT,
            maxTime: maxDT,
            currentTime: controller.text.isNotEmpty
                ? controller.text.toDateTime(dtFormat)
                : null,
            onConfirm: (dt) {
              controller.text = dt.format(dtFormat);
              if (onDateTimeChanged != null) {
                onDateTimeChanged!(dt);
              }
            },
          )
        : DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: minDT,
            maxTime: maxDT,
            currentTime: controller.text.isNotEmpty
                ? controller.text.toDateTime(dtFormat)
                : null,
            onConfirm: (dt) {
              controller.text = dt.format(dtFormat);
              if (onDateTimeChanged != null) {
                onDateTimeChanged!(dt);
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return isRequired
        ? WTextField.requiredField(
            label: label,
            onTap: () => _openPicker(context),
            hintText: hintText,
            controller: controller,
            enable: false,
            validator: validator,
            suffixIcon: Icon(
              dateOnly ? Icons.calendar_today_outlined : Icons.watch_later,
            ),
          )
        : WTextField(
            label: label,
            onTap: () => _openPicker(context),
            hintText: hintText,
            controller: controller,
            enable: false,
            validator: validator,
            suffixIcon: Icon(
              dateOnly ? Icons.calendar_today_outlined : Icons.watch_later,
            ),
          );
  }
}
