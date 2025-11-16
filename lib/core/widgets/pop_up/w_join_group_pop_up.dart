// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:momo/core/constants/colors.dart';
// import 'package:momo/core/constants/default_values.dart';
// import 'package:momo/core/constants/dimension_theme.dart';
// import 'package:momo/core/extensions/ex_build_context.dart';
// import 'package:momo/core/extensions/ex_padding.dart';
// import 'package:momo/core/widgets/w_custom_checkbox.dart';
// import 'package:momo/core/widgets/w_button.dart';
// import 'package:momo/core/widgets/w_container.dart';
// import 'package:momo/gen/assets.gen.dart';
// import '../../functions/f_url_launcher.dart';

// class WJoinGroupPopUp extends StatefulWidget {
//   const WJoinGroupPopUp({super.key});

//   @override
//   State<WJoinGroupPopUp> createState() => _WJoinGroupPopUpState();
// }

// class _WJoinGroupPopUpState extends State<WJoinGroupPopUp> {
//   bool isChecked = false;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.zero, // ✅ Removes default dialog margin
//       child: WContainer(
//         verticalPadding: 0,
//         horizontalPadding: 0,
//         height: 537.h,
//         width: 320.w,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(PTheme.borderRadius),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 40,
//                 child: Container(
//                   color: Colors.black,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Image.asset(
//                           Assets.images.x.path,
//                           width: double.infinity,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                       Text(
//                         "Something went wrong",
//                         style: context.primaryTextLarge?.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         "Item not found.",
//                         style: context.primaryTextSmall?.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ).pAll(),
//                 ),
//               ),
//               Expanded(
//                 flex: 60,
//                 child: Container(
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Join Group",
//                         style: context.primaryTextLarge?.copyWith(
//                           color: PColors.primayTextColorLight,
//                         ),
//                       ),
//                       Text(
//                         "You must join this community to test the apps. otherwise, they will be unavailable to you.",
//                         style: context.primaryTextSmall?.copyWith(
//                           color: PColors.secondaryTextColorLight,
//                         ),
//                         textAlign: TextAlign.justify,
//                       ),
//                       WContainer(
//                         verticalPadding: 5,
//                         horizontalPadding: 0,
//                         width: double.infinity,
//                         color: Color(0XFFEAEAEA),
//                         child: Text(
//                           PDefaultValues.googleGroupLink,
//                           style: context.primaryTextSmall?.copyWith(
//                             color: PColors.primayTextColorLight,
//                             fontWeight: FontWeight.bold,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ).pV(value: 20),
//                       // check trams and conditions
//                       gapY(10),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isChecked = !isChecked;
//                           });
//                         },
//                         child: Row(
//                           spacing: 10.w,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             WCustomcheckBox(scale: 1.sp, value: isChecked),
//                             Expanded(
//                               child: Text(
//                                 "I Confirm that I have joined the community group.",
//                                 style: context.primaryTextSmall?.copyWith(
//                                   fontSize: 10.sp,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Spacer(),
//                       Row(
//                         spacing: PTheme.spaceX,
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: () async {
//                                 Navigator.pop(context, 0);
//                               },
//                               child: Text("Remind me later"),
//                             ),
//                           ),
//                           Expanded(
//                             child: WPrimaryButton(
//                               gradientColors: [
//                                 Color(0xffEDEDED),
//                                 Color(0xffEDEDED),
//                               ],
//                               onTap: () async {
//                                 OpenURLs.open(
//                                   type: OpenType.url,
//                                   value: PDefaultValues.googleGroupLink,
//                                 );
//                               },
//                               textColor: context.theme.primaryColorLight,
//                               text: "Join Me",
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ).pAll(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
