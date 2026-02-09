import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/services/secret_service.dart';
import 'package:secure_note/core/widgets/image/m_image_payload.dart';
import 'package:secure_note/core/widgets/image/w_image.dart';
import 'package:secure_note/core/widgets/w_bottom_nav_button.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/view/secret/view/s_serets.dart';
import 'package:secure_note/features/profile/view/secret/widgets/w_opt.dart';
import 'package:secure_note/features/s_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';

class SSAuth extends StatefulWidget {
  final bool isSetkey; // true = user is setting new key (6 digits)
  final String? secondaryAuthKey;
  final String? serverSecondaryAuthKey;
  final int attemptCount;
  const SSAuth({
    super.key,
    this.isSetkey = false,
    this.secondaryAuthKey,
    this.serverSecondaryAuthKey,
    this.attemptCount = 0,
  });

  @override
  State<SSAuth> createState() => _SSAuthState();
}

class _SSAuthState extends State<SSAuth> {
  final GlobalKey<FormState> formKey = GlobalKey();

  // 6 controllers + 6 focus nodes
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  // Which OTP boxes are enabled (index)
  late List<int> enabledIndexes;
  int attemptCount = 0;
  CProfile cProfile = PowerVault.find<CProfile>();

  @override
  void initState() {
    super.initState();

    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());

    final otp = getEnabledBoxIndexs();
    enabledIndexes = widget.isSetkey ? [0, 1, 2, 3, 4, 5] : [otp.$1, otp.$2];
    attemptCount = widget.attemptCount;
    printer("initial print");
    printer(widget.isSetkey);
    printer(widget.secondaryAuthKey);
    printer(widget.serverSecondaryAuthKey);
  }

  @override
  void dispose() {
    controllers.map((e) => e.dispose());
    focusNodes.map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 40.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (widget.isSetkey && isNull(widget.serverSecondaryAuthKey)
                    ? "Set your 6-digit secret key."
                          "You cannot reset it."
                    : ""),
                style: context.textTheme?.bodySmall?.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
    
              gapY(40),
    
              /// Profile Image
              WImage(
                PDefaultValues.profileImage,
                payload: MImagePayload(
                  isCircular: true,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
    
              /// Title
              Column(
                children: [
                  Text(
                    "Secondary Authentication",
                    style: context.textTheme?.titleLarge?.copyWith(
                      fontFamily: "Custom",
                    ),
                  ),
                  Text(
                    (widget.isSetkey && isNull(widget.serverSecondaryAuthKey))
                        ? "Enter your new 6-digit key"
                        : "Enter the required digits",
                    style: context.textTheme?.bodyMedium?.copyWith(
                      fontFamily: "Custom",
                    ),
                  ),
                ],
              ),
    
              Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(6, (index) {
                    bool enabled = enabledIndexes.contains(index);
    
                    return WOTPBox(
                      contriller: enabled ? controllers[index] : null,
                      previous: index > 0 ? focusNodes[index - 1] : null,
                      current: focusNodes[index],
                      next: index < 5 ? focusNodes[index + 1] : null,
                      isEnable: enabled,
                    );
                  }),
                ),
              ),
    
              WBottomNavButton(label: "Submit", ontap: submit),
            ],
          ).pAll(),
        ),
      ),
    );
  }

  /// SUBMIT LOGIC
  void submit() async {
    if (formKey.currentState?.validate() ?? false) {
      final inputCode = controllers.map((c) => c.text).join();
      // new device/ first time login.
      if (widget.isSetkey) {
        SecretService secretService = SecretService();
        await secretService.init(inputCode + PDefaultValues.encryption);
        String encryptedString = secretService.encrypt(
          inputCode + PDefaultValues.encryption,
        );
        // save in firebase if it's first time
        if (isNull(widget.serverSecondaryAuthKey)) {
          await FirebaseFirestore.instance
              .collection(PKeys.users)
              .doc(cProfile.mProfileData.id)
              .collection(PKeys.eKey)
              .doc(PKeys.eKey)
              .set({"secondaryAuthKey": encryptedString});
        }
        // if it's new device verify. if success go ahede otherwise break and throw an error
        if (isNotNull(widget.serverSecondaryAuthKey)) {
          if (encryptedString == widget.serverSecondaryAuthKey) {
            // verifyed
            // showSnackBar("Verifyed");
          } else {
            // unverifyed
            showSnackBar("Wrong Sunmition", snackBarType: SnackBarType.warning);
            return; // stop process
          }
        }
        // set in runtime storage and local storage
        cProfile.hash = (inputCode + PDefaultValues.encryption);
        await FSSService().setString(
          "secondaryAuthKey",
          inputCode + PDefaultValues.encryption,
        );

        printer(inputCode);
        SSerets().pushReplacement();
        showSnackBar("Your 6-digit key is: $inputCode");
        return;
      }
      // when user verifying
      else {
        if (widget.secondaryAuthKey!.substring(
              enabledIndexes.first, // x
              enabledIndexes.last + 1, // x+2
            ) ==
            inputCode) {
          printer("Verifyed!");
          await FSSService().delete("attemptCount");
          SecretService secretService = SecretService();
          await secretService.init(widget.secondaryAuthKey!);
          SSerets().pushReplacement();
          return;
        } else {
          showSnackBar("Wrong!!!", snackBarType: SnackBarType.warning);
          errorPrint(inputCode);
          errorPrint(widget.secondaryAuthKey);
        }

        attemptCount++;
        printer("attemptCount $attemptCount");
        if (attemptCount > 3) {
          // lock this account.
          SHome(selectedPage: 4).pushAndRemoveUntil();
          showSnackBar(
            "Your account has locked!",
            snackBarType: SnackBarType.important,
          );
        }
        await FSSService().setString("attemptCount", attemptCount.toString());
      }
    } else {
      showSnackBar(
        "Please fill all required fields!",
        snackBarType: SnackBarType.warning,
      );
    }
  }
}

/// OTP index selection logic
(int, int) getEnabledBoxIndexs() {
  final random = Random();
  // 1-5 index
  int number = random.nextInt(5) + 1;
  return (number - 1, number);
}
