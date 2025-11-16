import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/widgets/w_form_field_wrapper.dart';
import 'package:flutter/material.dart';

/// 📊 WSegmentedButtonFormField<>
/// A segmented button group integrated with form validation.
/// 📋 Supports any generic type [T]
/// 🛑 Handles required validation
/// 🪄 Auto styles segments based on selected state
/// 🏷️ Optional [title] + error message shown via [WFormFieldWrapper]
class WSegmentedButtonFormField<T> extends StatelessWidget {
  final String? title;
  final bool isRequired;
  final List<T> options;
  final void Function(T?)? onChanged;

  const WSegmentedButtonFormField({
    super.key,
    this.title,
    this.isRequired = false,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T?>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (isRequired && (value == null)) {
          return "required";
        }
        return null;
      },
      builder: (formFieldState) {
        return WFormFieldWrapper(
          title: title,
          isRequired: isRequired,
          errorText: formFieldState.errorText,
          child: SegmentedButton<T>(
            expandedInsets: EdgeInsets.zero,
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            segments: options
                .map(
                  (e) => ButtonSegment<T>(
                    value: e,
                    label: Center(child: Text(e.toString())),
                  ),
                )
                .toList(),
            selected: formFieldState.value != null
                ? <T>{formFieldState.value as T}
                : <T>{},
            onSelectionChanged: (sel) {
              T? newValue = sel.isEmpty ? null : sel.first;
              formFieldState.didChange(newValue);
              onChanged?.call(newValue);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return context.theme.primaryColor;
                }
                return context.fillColor!;
              }),
              side: WidgetStatePropertyAll(
                BorderSide(
                  color: formFieldState.hasError
                      ? context.redColor
                      : context.theme.primaryColor,
                ),
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return context.theme.textTheme.headlineLarge!.color!;
                }
                return context.textTheme!.titleMedium!.color!;
              }),
              minimumSize: WidgetStatePropertyAll(
                Size.fromHeight(PTheme.buttonHeight),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(PTheme.borderRadius),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
