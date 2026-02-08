import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/image/m_image_payload.dart';
import 'package:secure_note/core/widgets/image/w_image.dart';
import 'package:secure_note/core/widgets/w_card.dart';
import 'package:secure_note/features/authentication/views/s_sign_in.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/data/data_source/profile_data_source_impl.dart';
import 'package:secure_note/features/profile/data/models/m_setting_item.dart';
import 'package:secure_note/features/profile/data/repository/patient_repository_impl.dart';
import 'package:secure_note/features/profile/view/s_edit_profile.dart';
import 'package:secure_note/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:power_state/power_state.dart';

class SProfile extends StatefulWidget {
  const SProfile({super.key});

  @override
  State<SProfile> createState() => _SProfileState();
}

class _SProfileState extends State<SProfile> {
  CProfile cProfile = PowerVault.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBackFunction(() {
      cProfile.getPatientList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigationService.currentContext.backgroundColor,
      appBar: AppBar(title: Text("Settings"), actions: [
          
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: PTheme.paddingY,
          children: [
            // top items
            _WProfile(),

            // profile items
            WCard(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: profileItem.length,
                itemBuilder: (_, index) {
                  return _WSItem(
                    label: profileItem[index].label,
                    iconData: profileItem[index].icon,
                    onTap: profileItem[index].onTap,
                    isLastitem: profileItem.length - 1 == index,
                    child: profileItem[index].child,
                  ).withKey(ValueKey(UniqueKey));
                },
              ),
            ),
            // profile items
            WCard(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: menuList.length,
                itemBuilder: (_, index) {
                  return _WSItem(
                    label: menuList[index].label,
                    iconData: menuList[index].icon,
                    onTap: menuList[index].onTap,
                    isLastitem: menuList.length - 1 == index,
                    child: menuList[index].child,
                  );
                },
              ),
            ),

            // version label
            Text("Version 2.9.1", style: context.textTheme?.bodyMedium),
          ],
        ).pAll(),
      ),
    );
  }

  // top profile section
  Widget _WProfile() {
    return PowerBuilder<CProfile>(
      builder: (cProfile) {
        // printer("_WProfile ${cProfile.mProfileData.toJson()}");
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.button?.primary,
                borderRadius: BorderRadius.circular(PTheme.borderRadius),
              ),
              height: 200.h,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20.h,
                children: [
                  WImage(
                    cProfile.mProfileData?.image,
                    payload: MImagePayload(
                      height: 100.r,
                      width: 100.r,
                      isProfileImage: true,
                      isCircular: true,
                    ),
                  ),
                  if (cProfile.isSigned)
                    Column(
                      children: [
                        Text(
                          cProfile.mProfileData?.name ?? PDefaultValues.noName,
                          style: context.textTheme?.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          cProfile.mProfileData?.email ?? PDefaultValues.noName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  if (!cProfile.isSigned)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: PTheme.paddingX,
                      children: [
                        GestureDetector(
                          onTap: () => SSignIn().push(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              borderRadius: BorderRadius.circular(
                                PTheme.borderRadius,
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: context.textTheme?.titleSmall,
                            ).pAll(value: 5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => SSignIn(isSignIn: false).push(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              borderRadius: BorderRadius.circular(
                                PTheme.borderRadius,
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: context.textTheme?.titleSmall,
                            ).pAll(value: 5),
                          ),
                        ),
                      ],
                    ),
                ],
              ).pAll(),
            ),
            if (cProfile.isSigned)
              Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                  onTap: () {
                    SEditProfile().push();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      borderRadius: BorderRadius.circular(PTheme.borderRadius),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: context.textTheme?.titleSmall,
                    ).pAll(value: 5),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _WSItem extends StatelessWidget {
  final String label;
  final String iconData;
  final Function() onTap;
  final bool isLastitem;
  final Widget? child;
  const _WSItem({
    super.key,
    required this.label,
    required this.iconData,
    required this.onTap,
    this.isLastitem = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              SvgPicture.asset(
                iconData,
                colorFilter: ColorFilter.mode(
                  context.primaryTextColor ?? Colors.grey,
                  BlendMode.srcIn,
                ),
                errorBuilder: (context, error, stackTrace) => Text("ERROR!"),
                height: 20.w,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    label, // the text
                    style: context.textTheme?.titleSmall,
                  ),
                ),
              ),
              !isNull(child)
                  ? SizedBox(width: 100.w, child: child!)
                  : Icon(
                      Icons.keyboard_arrow_right,
                      color: context.primaryTextColor,
                      size: 25.w,
                    ),
            ],
          ).pAll(),
        ),
        if (!isLastitem) SizedBox().pDivider(),
      ],
    );
  }
}
