import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/data/local/db_local.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/functions/f_url_launcher.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/view/s_faq.dart';
import 'package:secure_note/features/profile/view/secret/view/s_secondary_auth.dart';
import 'package:secure_note/gen/assets.gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:power_state/power_state.dart';

class MSItem {
  final String icon;
  final String label;
  final Function() onTap;
  final Widget? child;
  MSItem({
    this.child,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

List<MSItem> profileItem = [
  MSItem(
    icon: Assets.icons.clear,
    label: "Clear All History",
    onTap: () {
      WDialog.show(
        title: "Clear All History",
        content: "Are you sure you want clear all history?",
        context: NavigationService.currentContext,
        onConfirm: () async {
          try {
            await DBHelper.getInstance.clear();
            showSnackBar("History Cleared");
          } catch (e) {
            errorPrint(e);
            showSnackBar(
              "Somthing Want Wrong!",
              snackBarType: SnackBarType.warning,
            );
          }
        },
      );
    },
  ),
  MSItem(
    icon: Assets.icons.vault,
    label: "Secret Vault",
    onTap: () async {
      CProfile cProfile = PowerVault.find<CProfile>();
      // user already signed
      if (cProfile.isSigned) {
        String? secondaryAuthKey = await FSSService().getString(
          "secondaryAuthKey",
        );
        String? attemptCount = await FSSService().getString("attemptCount");
        if (isNotNull(secondaryAuthKey)) {
          // key found in local sotrage so verify user.
          if (int.parse(attemptCount ?? "0") > 3) {
            showSnackBar(
              "Account Was Locked",
              snackBarType: SnackBarType.warning,
            );
          } else {
            SSAuth(
              isSetkey: false,
              attemptCount: int.parse(attemptCount ?? "0"),
              secondaryAuthKey: secondaryAuthKey,
            ).push();
          }
        } else {
          // first signin, or new device sign in
          FirebaseFirestore.instance
              .collection(PKeys.users)
              .doc(cProfile.uid)
              .collection(PKeys.eKey)
              .doc(PKeys.eKey)
              .get()
              .then((DocumentSnapshot snapshot) {
                final data = snapshot.data();
                if (isNotNull(data) &&
                    isNotNull(
                      (data as Map<String, dynamic>)["secondaryAuthKey"],
                    )) {
                  // key found in server
                  // so set key in local storage
                  SSAuth(
                    isSetkey: true,
                    serverSecondaryAuthKey: data["secondaryAuthKey"],
                  ).push();
                } else {
                  // key not found in server so set key
                  SSAuth(isSetkey: true).push();
                }
              })
              .onError((e, l) {});
        }
      } else {
        showSnackBar("Please Sign In !!!", snackBarType: SnackBarType.warning);
      }
    },
  ),
  MSItem(
    icon: Assets.icons.profile,
    label: "User ID",
    onTap: () {
      CProfile cProfile = PowerVault.find<CProfile>();
      Clipboard.setData(
        ClipboardData(text: cProfile.mProfileData.id ?? PDefaultValues.noName),
      );
      showSnackBar("Copyed!");
    },
    child: _WCopyButton(),
  ),
];

List<MSItem> menuList = [
  // MSItem(
  //   icon: Assets.icons.restorePurchase,
  //   label: "Restore Purchase",
  //   onTap: () {
  //     showSnackBar("Under build");
  //   },
  // ),
  MSItem(
    icon: Assets.icons.faq,
    label: "FAQ",
    onTap: () {
      SFaq().push();
    },
  ),
  MSItem(
    icon: Assets.icons.feedback,
    label: "Feedback",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.rating,
    label: "Rate Us",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.tramsOfUse,
    label: "Terms of Use",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.termsConditionUrl);
    },
  ),
  MSItem(
    icon: Assets.icons.privacyAndPolicy,
    label: "Privacy Policy",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.privacyUrlLink);
    },
  ),
  MSItem(
    icon: Assets.icons.power,
    label: "SignOut For All Devices",
    onTap: () async {
      WDialog.confirmExitLogout(
        context: NavigationService.currentContext,
        isLogOut: true,
        onYesPressed: () {
          Navigation.pop();
          CProfile cProfile = PowerVault.find<CProfile>();
          cProfile.changeSessionKey();
        },
      );
    },
  ),
  MSItem(
    icon: Assets.icons.power,
    label: "SignOut",
    onTap: () async {
      WDialog.confirmExitLogout(
        context: NavigationService.currentContext,
        isLogOut: true,
        onYesPressed: () {
          CProfile cProfile = PowerVault.find<CProfile>();
          cProfile.logOut();
        },
      );
    },
  ),
];

class _WCopyButton extends StatelessWidget {
  _WCopyButton({super.key});
  CProfile cProfile = PowerVault.find<CProfile>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PowerBuilder<CProfile>(
          builder: (cProfile) {
            return Expanded(
              child: Text(
                cProfile.mProfileData.id ?? PDefaultValues.noName,
                style: context.textTheme?.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ).pR(),
            );
          },
        ),
        Icon(Icons.file_copy, color: context.primaryTextColor),
      ],
    );
  }
}
