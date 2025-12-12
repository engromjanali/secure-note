import 'dart:io';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/services/image_picker_services.dart';
import 'package:secure_note/core/widgets/w_bottom_nav_button.dart';
import 'package:secure_note/core/widgets/w_image_source_dialog.dart';
import 'package:secure_note/features/profile/data/models/m_profile.dart';
import '/core/extensions/ex_build_context.dart';
import '/core/extensions/ex_keyboards.dart';
import '/core/extensions/ex_padding.dart';
import '/core/extensions/ex_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:power_state/power_state.dart';
import '/core/constants/dimension_theme.dart';
import '/core/functions/f_is_null.dart';
import '/core/widgets/image/m_image_payload.dart';
import '/core/widgets/image/w_image.dart';
import '/core/widgets/w_text_field.dart';
import '../controllers/c_profile.dart';

class SEditProfile extends StatefulWidget {
  const SEditProfile({super.key});

  @override
  State<SEditProfile> createState() => _SEditProfileState();
}

class _SEditProfileState extends State<SEditProfile> {
  final CProfile cProfile = PowerVault.find<CProfile>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<XFile> selectedImage = ValueNotifier(XFile(""));
  MProfile payload = MProfile();

  void _onUpdate() {
    context.unFocus();
    if (_formKey.currentState?.validate() ?? false) {
      cProfile.editPrifle(payload);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    payload.id = cProfile.mProfileData?.id;
    payload.name = cProfile.mProfileData?.name;
    payload.email = cProfile.mProfileData?.email;
  }

  @override
  void dispose() {
    selectedImage.dispose();
    payload = MProfile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text("Edit prfile"), centerTitle: true),
      bottomNavigationBar: WBottomNavButton(
        label: 'Update',
        ontap: () {
          showSnackBar("We Have Issue With Password, Check On Change Field!");
        },
        // child: PowerBuilder<CProfile>(
        //   builder: (controller) {
        //     final isLoading = controller.viewState == ViewState.loading;
        //     return WPrimaryButton(
        //       text: "Update",
        //       isLoading: isLoading,
        //       onTap: _onUpdate,
        //     );
        //   },
        // ),
      ).pAll(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: PTheme.paddingX,
          vertical: PTheme.paddingY,
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedImage,
                      builder: (_, image, __) {
                        return InkWell(
                          onTap: () async {
                            ImageSource? res = await WISSDialog(context);
                            if (isNotNull(res)) {
                              selectedImage.value =
                                  await SvImagePicker().pickSingleImage(
                                    choseFrom: res!,
                                  ) ??
                                  selectedImage.value;
                              payload.image = selectedImage.value.path;
                            }
                          },
                          child: isNull(image.path)
                              ? PowerBuilder<CProfile>(
                                  builder: (controller) {
                                    return WImage(
                                      controller.mProfileData?.image,
                                      payload: MImagePayload(
                                        height: 100.h,
                                        width: 100.w,
                                        isCircular: true,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 100.h,
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                    color: context.indicatorColor,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(File(image.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),

                WTextField.requiredField(
                  initialText: cProfile.mProfileData?.name,
                  label: "Full Name",
                  onChanged: (v) {
                    payload.name = v;
                  },
                ).pB(),

                WTextField.requiredField(
                  initialText: cProfile.mProfileData?.email,
                  label: "Email Address",
                  validator: (value) {
                    if (value == null) return "Enter Email!";
                    if (!value.isValidEmail) return "Invalid Email!";
                    return null;
                  },
                  onChanged: (v) {
                    payload.email = v;
                  },
                ).pB(),
                WTextField.obsecureText(
                  isRequired: true,
                  label: "Password",
                  hintText: "Enter password",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (value.contains(" ")) return "Spaces not allowed!";
                    if (value.trim().length < 6) {
                      return "Use minimum of six letters!";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    // payload.password = v;
                  },
                ).pB(value: 16),
                WTextField.obsecureText(
                  isRequired: false,
                  label: "New Password",
                  hintText: "Enter password (ignore, if you don't want change)",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (value.contains(" ")) return "Spaces not allowed!";
                    if (value.trim().length < 6) {
                      return "Use minimum of six letters!";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    // payload.password = v;
                  },
                ).pB(value: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
