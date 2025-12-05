import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_keyboards.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/extensions/ex_strings.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_button.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:daily_info/core/widgets/w_pop_button.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WSDuration extends StatelessWidget {
  GlobalKey<FormState> fromKey = GlobalKey();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();
  WSDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PTheme.spaceX,
      children: [
        Text("Select Duration", style: context.textTheme?.titleMedium).pB(),
        Form(
          key: fromKey,
          child: Column(
            spacing: 10.h,
            children: [
              WTextField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!(value?.isValidInt ?? false)) {
                    return "Invalid";
                  }
                  return null;
                },
                label: "Hours",
                controller: hoursController,
              ),
              WTextField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!(value?.isValidInt ?? false)) {
                    return "Invalid";
                  }
                  return null;
                },
                label: "Minutes",
                controller: minutesController,
              ),
              WTextField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!(value?.isValidInt ?? false)) {
                    return "Invalid";
                  }
                  return null;
                },
                label: "Seconds",
                controller: secondsController,
                onTap: () {},
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        WCElevatedButton(
          label: "Ok",
          foregroundColor: context.theme.scaffoldBackgroundColor,
          backgroundColor: context.textTheme?.titleLarge?.color,
          ontap: () {
            if (fromKey.currentState?.validate() ?? false) {
              int hours = int.parse(hoursController.text);
              int minutes = int.parse(minutesController.text);
              int seconds = int.parse(secondsController.text);
              Navigation.pop(
                data: Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                ),
              );
            }
          },
          margin: EdgeInsets.all(0),
        ),
      ],
    );
  }
}
