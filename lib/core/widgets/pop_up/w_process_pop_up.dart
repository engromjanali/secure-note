// import 'package:flutter_svg/svg.dart';

// import './/core/constants/dimension_theme.dart';
// import './/core/extensions/ex_build_context.dart';
// import './/core/extensions/ex_expanded.dart';
// import './/core/extensions/ex_padding.dart';
// import './/core/functions/f_url_launcher.dart';
// import './/core/widgets/w_button.dart';
// import './/core/widgets/w_container.dart';
// import './/gen/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class WProcessPopUp extends StatefulWidget {
//   final String? testingUrl;
//   const WProcessPopUp({super.key, this.testingUrl});

//   @override
//   State<WProcessPopUp> createState() => _WProcessPopUpState();
// }

// class _WProcessPopUpState extends State<WProcessPopUp> {
//   int itemCount = 14;
//   int selectedItem = 10 - 1;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.all(0),
//       child: Center(
//         child: WContainer(
//           width: 320.w,
//           height: 374.h,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Upload Process",
//                 style: context.primaryTextSmall
//                     ?.copyWith(fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 "1 of 14 day completed",
//                 style: context.primaryTextSmall
//                     ?.copyWith(fontWeight: FontWeight.w500, fontSize: 8.sp),
//               ).pV(value: 2),
//               Row(
//                 children: List.generate(
//                   itemCount,
//                   (index) => Container(
//                     height: 3.h,
//                     decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(PTheme.borderRadius),
//                         color: index == selectedItem
//                             ? Color(0xff07B114)
//                             : Colors.grey),
//                   ).pH(value: 2).expd(),
//                 ),
//               ).pB(),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Open App",
//                       style: context.primaryTextLarge,
//                     ).pV(),
//                     Expanded(
//                       child: SvgPicture.asset(
//                         Assets.logo.openApp,
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                     Text(
//                       "Open and test all functionalities of tha app",
//                       style: context.primaryTextSmall
//                           ?.copyWith(fontWeight: FontWeight.w500),
//                     ).pV(),
//                     WPrimaryButton(
//                       height: 40.h,
//                       width: 155.w,
//                       text: "Open App",
//                       onTap: () async {
//                         OpenURLs.open(
//                             type: OpenType.url, value: widget.testingUrl ?? "");
//                         Navigator.pop(context, true);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
