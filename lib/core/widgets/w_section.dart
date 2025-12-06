// import 'package:secure_note/core/constants/all_enums.dart';
// import 'package:secure_note/core/constants/dimension_theme.dart';
// import 'package:secure_note/core/extensions/ex_build_context.dart';
// import 'package:secure_note/core/extensions/ex_date_time.dart';
// import 'package:secure_note/core/extensions/ex_duration.dart';
// import 'package:secure_note/core/extensions/ex_expanded.dart';
// import 'package:secure_note/core/extensions/ex_padding.dart';
// import 'package:secure_note/core/functions/f_is_null.dart';
// import 'package:secure_note/core/widgets/w_listtile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sliver_tools/sliver_tools.dart';

// class WTaskSection extends StatelessWidget {
//   final Color? leadingColor;
//   final String? title;
//   final int itemCount;
//   final TaskState taskState;
//   final String trailingLabel;
//   final bool asSliver;

//   const WTaskSection({
//     super.key,
//     required this.title,
//     required this.itemCount,
//     this.leadingColor,
//     required this.taskState,
//     this.trailingLabel = "See All",
//     this.asSliver = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SliverPadding(
//       padding: EdgeInsets.only(bottom: 10.h),
//       sliver: MultiSliver(
//         children: [
//           if (isNotNull(title))
//             SliverToBoxAdapter(
//               child: Row(
//                 spacing: PTheme.spaceX,
//                 children: [
//                   Icon(
//                     Icons.circle,
//                     color: leadingColor,
//                     size: context.textTheme?.titleSmall?.fontSize,
//                   ),
//                   Text(
//                     title!,
//                     style: context.textTheme?.titleSmall?.copyWith(
//                       color: leadingColor,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ).pR().expd(),
//                   Row(
//                     children: [
//                       Text(
//                         trailingLabel,
//                         style: context.textTheme?.titleSmall?.copyWith(
//                           color: context.button?.primary,
//                         ),
//                       ),
//                       if (isNotNull(trailingLabel)) Icon(Icons.arrow_right),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           SliverList.builder(
//             itemBuilder: (context, index) {
//               String dateTime = DateTime.now().format(
//                 DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
//               );
//               String status = taskState == TaskState.pending
//                   ? (Duration(hours: 1, minutes: 1, seconds: 60) -
//                             Duration(seconds: DateTime.now().second))
//                         .as_XX_XX_XX
//                   : taskState == TaskState.completed
//                   ? "Completed"
//                   : "Time-Out";
//               return WListTile(
//                 leadingColor: leadingColor,
//                 onTap: () {},
//                 index: index,
//                 title:
//                     "Mobile App Reacharch Application has Created By Md Romjan Ali",
//                 subTitle: "$dateTime | $status",
//                 // status:""
//               );
//             },
//             itemCount: itemCount,
//           ),
//         ],
//       ),
//     );
//   }
// }
