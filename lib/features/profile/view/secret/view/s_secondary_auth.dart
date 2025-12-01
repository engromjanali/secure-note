import 'dart:math';
import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/image/m_image_payload.dart';
import 'package:daily_info/core/widgets/image/w_image.dart';
import 'package:daily_info/core/widgets/w_bottom_nav_button.dart';
import 'package:daily_info/features/profile/view/secret/view/s_add_sencitive_note.dart';
import 'package:daily_info/features/profile/view/secret/view/s_serets.dart';
import 'package:daily_info/features/profile/view/secret/widgets/w_opt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SSAuth extends StatefulWidget {
  final bool isSetkey;
  const SSAuth({super.key, this.isSetkey = false});

  @override
  State<SSAuth> createState() => _SSAuthState();
}

class _SSAuthState extends State<SSAuth> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  GlobalKey<FormState> fromKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    (int, int) enabledPairOTP = getEnabledOTPBox();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 40.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Note you will not able to change or forget this key leter, so remember it.",
                style: context.textTheme?.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ),
              gapY(100),
              WImage(
                PDefaultValues.profileImage,
                payload: MImagePayload(
                  isCircular: true,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Text(
                    "Secondary Authentication",
                    style: context.textTheme?.titleLarge?.copyWith(
                      fontFamily: "Custom",
                    ),
                    textAlign: TextAlign.center,
                  ).pB(),
                  Text(
                    "Please enter your security number",
                    style: context.textTheme?.bodyMedium?.copyWith(
                      fontFamily: "Custom",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              Form(
                key: fromKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    6,
                    (index) => WOTPBox(
                      contriller: enabledPairOTP.$1 == index
                          ? controller1
                          : enabledPairOTP.$2 == index
                          ? controller2
                          : null,
                      previous: enabledPairOTP.$2 == index ? focusNode1 : null,
                      current: enabledPairOTP.$1 == index
                          ? focusNode1
                          : enabledPairOTP.$2 == index
                          ? focusNode2
                          : null,
                      next: enabledPairOTP.$1 == index ? focusNode2 : null,
                    ),
                  ),
                ),
              ),

              WBottomNavButton(label: "Submit", ontap: submit),
            ],
          ).pAll(),
        ),
      ),
    );
  }

  void submit() {
    if (fromKey.currentState?.validate() ?? false) {
      showSnackBar("valided \$${controller1.text} \$${controller2.text}");
      SSerets().push();
    } else {
      showSnackBar(
        snackBarType: SnackBarType.warning,
        "Please Fill All Required Field!",
      );
    }
  }
}

(int, int) getEnabledOTPBox() {
  final random = Random();
  int number = random.nextInt(5) + 1; // 1 to 5
  return (number - 1, number);
}
