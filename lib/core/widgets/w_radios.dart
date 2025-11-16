import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/widgets/w_container.dart';
import 'package:daily_info/core/widgets/w_form_field_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

/// 🔘 MRadios
/// A reusable radio button group inside a form field.
/// 🧠 Maps a list of strings to radio options
/// 🛡️ Built-in validation for required fields
/// 🎨 Styled with border, background, and optional title
/// 📌 Callbacks:
/// • [onChanged] updates external state
/// • Uses `FormField` to sync with form validation

class MRadios extends StatelessWidget {
  final String? title;
  final bool isRequired;
  final List<String> options;
  final String? initialValue;
  final void Function(String?)? onChanged;

  const MRadios({
    super.key,
    this.title,
    required this.options,
    this.onChanged,
    this.initialValue,
  }) : isRequired = false;

  const MRadios.required({
    super.key,
    this.title,
    required this.options,
    this.onChanged,
    this.initialValue,
  }) : isRequired = true;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "required";
        }
        return null;
      },
      builder: (formFieldState) {
        return WFormFieldWrapper(
          title: title,
          isRequired: isRequired,
          errorText: formFieldState.errorText,
          child: WContainer(
            color: context.fillColor,
            horizontalPadding: PTheme.spaceX,
            verticalPadding: 4.h,
            borderColor: formFieldState.hasError ? context.redColor : Colors.transparent,
            child: Wrap(
              spacing: 12,
              children: options.map((String option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: formFieldState.value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (String? value) {
                        formFieldState.didChange(value);
                        onChanged?.call(value);
                      },
                    ),
                    Text(option),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
