import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/widgets/w_container.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WDropdown<T> extends FormField<T> {
  WDropdown({
    super.key,
    required String label,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
    T? selectedValue, // 👈 new external control
    String? hintText,
    bool isRequired = false,
    FormFieldValidator<T>? validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
  }) : super(
         initialValue: selectedValue, // 👈 connect to FormField
         validator:
             validator ??
             (isRequired
                 ? (val) {
                     if (val == null) return "Please select $label";
                     return null;
                   }
                 : null),
         builder: (FormFieldState<T> state) {
           final _DropdownStatefulWrapper<T> wrapper =
               _DropdownStatefulWrapper<T>(
                 label: label,
                 items: items,
                 itemLabelBuilder: itemLabelBuilder,
                 onChanged: onChanged,
                 hintText: hintText,
                 isRequired: isRequired,
                 state: state,
                 selectedValue: selectedValue,
               );
           return wrapper;
         },
       );
}

/// This wrapper makes the dropdown reactive to external changes
class _DropdownStatefulWrapper<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final bool isRequired;
  final FormFieldState<T> state;
  final T? selectedValue;

  const _DropdownStatefulWrapper({
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    required this.state,
    required this.isRequired,
    this.hintText,
    this.selectedValue,
  });

  @override
  State<_DropdownStatefulWrapper<T>> createState() =>
      _DropdownStatefulWrapperState<T>();
}

class _DropdownStatefulWrapperState<T>
    extends State<_DropdownStatefulWrapper<T>> {
  @override
  void didUpdateWidget(covariant _DropdownStatefulWrapper<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 👇 If external value changed, sync it with form field state
    if (widget.selectedValue != oldWidget.selectedValue &&
        widget.selectedValue != widget.state.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.state.didChange(widget.selectedValue);
      });
    }
  }

  void openSearchDialog() async {
    final state = widget.state;
    final context = state.context;
    TextEditingController searchController = TextEditingController();
    List<T> tempList = widget.items;

    final result = await WDialog.showCustom(
      context: context,
      children: [
        StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select ${widget.label}',
                  style: context.textTheme?.titleMedium,
                ),
                WTextField(
                  controller: searchController,
                  hintText: "Search...",
                  onChanged: (val) {
                    setDialogState(() {
                      tempList = widget.items
                          .where(
                            (e) => widget
                                .itemLabelBuilder(e)
                                .toLowerCase()
                                .contains(val.toLowerCase()),
                          )
                          .toList();
                    });
                  },
                ).pB(),
                SizedBox(
                  width: double.maxFinite,
                  height: 200.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: tempList.length,
                    itemBuilder: (_, index) {
                      final item = tempList[index];
                      return ListTile(
                        title: Text(
                          widget.itemLabelBuilder(item),
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.pop(context, item),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );

    if (result != null) {
      state.didChange(result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final selectedItem = state.value;
    final hasError = state.hasError;
    final errorText = state.errorText;
    final labelStyle = context.textTheme?.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.label, style: labelStyle),
            if (widget.isRequired)
              Text(
                " *",
                style: context.textTheme?.bodyMedium?.copyWith(color: Colors.red),
              ),
          ],
        ).pB(value: 5),
        WContainer(
          onTap: openSearchDialog,
          verticalPadding: PTheme.spaceY + 2.h,
          borderColor: hasError ? Colors.red : Colors.grey.withAlpha(120),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedItem != null
                      ? widget.itemLabelBuilder(selectedItem)
                      : (widget.hintText ?? 'Select ${widget.label}'),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selectedItem != null
                        ? context.textTheme?.titleMedium!.color
                        : context.textTheme?.titleMedium!.color,
                    fontSize: selectedItem != null ? 14.sp : 12.sp,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 10.w),
            child: Text(
              errorText!,
              style: context.textTheme?.bodyMedium?.copyWith(
                color: context.redColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
