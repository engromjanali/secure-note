import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_keyboards.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WOTPBox extends StatelessWidget {
  FocusNode? previous;
  FocusNode? current;
  FocusNode? next;
  TextEditingController? contriller;
  WOTPBox({super.key, this.previous, this.current, this.next, this.contriller});

  @override
  Widget build(BuildContext context) {
    bool isEnable = isNotNull(current);
    return SizedBox(
      width: 50.w,
      height: 50.w,
      child: TextFormField(
        initialValue: isEnable ? null : "*",
        controller: contriller,
        focusNode: current,
        expands: true,
        maxLines: null,
        textAlign: TextAlign.center,
        maxLength: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: isEnable,
        validator: (value) {
          if (isNull(value) && isNotNull(current)) return "";
        },
        errorBuilder: (context, errorText) => SizedBox.shrink(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(PTheme.borderRadius),
            ),
            borderSide: BorderSide(
              color: context.button?.primary ?? Colors.blue,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(PTheme.borderRadius),
            ),
            borderSide: BorderSide(
              color: context.button?.primary ?? Colors.blue,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (isNotNull(next)) {
              context.switchFocus(
                // unfocusNode: current!,
                nextFocusNode: next!,
              );
            } else {
              context.unFocus(); // last box
            }
          }
          if (value.isEmpty && isEnable && isNotNull(previous)) {
            context.switchFocus(
              // unfocusNode: current!,
              nextFocusNode: previous!,
            );
          }
        },
      ),
    );
  }
}
