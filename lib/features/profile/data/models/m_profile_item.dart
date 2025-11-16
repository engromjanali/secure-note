import 'package:flutter/material.dart';
import '../../../../../gen/assets.gen.dart';

class MProfileItem {
  String? logo;
  String? title;
  Function()? onTap;
  Widget? trailing;

  MProfileItem({this.logo, this.title, this.onTap, this.trailing});
}

List<MProfileItem> myProfileList = [
  MProfileItem(
    logo: Assets.logo.editProfile,
    title: "Edit profile",
    // onTap: () => SEditProfile().push(),
  ),
  MProfileItem(
    logo: Assets.logo.uploadApp,
    title: "Uplaod App",
    // onTap: () => SSubmitAppDetails().push(),
  ),
  MProfileItem(
    logo: Assets.logo.myApps,
    title: "My Apps",
    // onTap: () => SMyApps().push(),
  ),
  MProfileItem(
    logo: Assets.logo.settings,
    title: "Settings",
    // onTap: () => SSettings().push(),
  ),
];
List<MProfileItem> appSettingsList = [
  MProfileItem(
    logo: Assets.logo.myApps,
    title: "My Apps",
    // onTap: () => WMyApps().push(),
  ),
  MProfileItem(
    logo: Assets.logo.settings,
    title: "Settings",
    // onTap: () => SSettings().push(),
  ),
  MProfileItem(
    logo: Assets.logo.community,
    title: "Join Community",
    onTap: () async {
      // await WDialog.showCustom(
      //   context: NavigationService.currentContext,
      //   children: [WJoinGroupPopUp()],
      // );
    },
  ),
  MProfileItem(
    logo: Assets.logo.community,
    title: "Join Community",
    onTap: () async {
      // await WDialog.showCustom(
      //   context: NavigationService.currentContext,
      //   children: [WJoinGroupPopUp()],
      // );
    },
  ),
];

// App Section
List<MProfileItem> appSectionList = [
  MProfileItem(
    logo: Assets.logo.editProfile,
    title: "FAQs",
    // onTap: () => SFaq().push(),
  ),
  MProfileItem(logo: Assets.logo.uploadApp, title: "Support"),
  MProfileItem(
    logo: Assets.logo.google,
    title: "Join Google Group",
    onTap: () async {
      // await WDialog.showCustom(
      //   context: NavigationService.currentContext,
      //   children: [WJoinGroupPopUp()],
      // );
    },
  ),
];

// // other Settings
// final CTheme cTheme = Get.find();
// List<MProfileItem> otherSettingsList = [
//   // MProfileItem(
//   //   title: "English",
//   //   trailing: Icon(Icons.arrow_drop_down),
//   // ),
//   MProfileItem(
//     title: cTheme.currentTheme.brightness == Brightness.dark
//         ? "Switch Dark Mode"
//         : "Switch Light Mode",
//     trailing: cTheme.currentTheme.brightness == Brightness.dark
//         ? Icon(Icons.dark_mode)
//         : Icon(Icons.light_mode),
//     onTap: () {
//       otherSettingsList[0].trailing =
//           cTheme.currentTheme.brightness == Brightness.dark
//           ? Icon(Icons.dark_mode)
//           : Icon(Icons.light_mode);

//       otherSettingsList[0].title =
//           cTheme.currentTheme.brightness == Brightness.dark
//           ? "Switch Dark Mode"
//           : "Switch Light Mode";

//       cTheme.updateTheme();
//     },
//   ),
//   MProfileItem(title: "Policies"),
// ];
