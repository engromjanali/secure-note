import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:flutter/material.dart';

class WSNoteType extends StatelessWidget {
  const WSNoteType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Select Note Type",
          style: context.textTheme?.titleSmall,
        ).pB(value: 40),
        WCElevatedButton(
          ontap: () {
            Navigation.pop(data: NoteType.sencetive);
          },
          backgroundColor: context.textTheme?.titleSmall?.color,
          foregroundColor: context.backgroundColor,
          label: "Sencetive Note",
          margin: EdgeInsets.all(0),
        ).pB(),
        WCElevatedButton(
          ontap: () {
            Navigation.pop(data: NoteType.reguler);
          },
          label: "Reguler Note",
          foregroundColor: context.textTheme?.titleLarge?.color,
          backgroundColor: context.backgroundColor,
          margin: EdgeInsets.all(0),
        ),
      ],
    );
  }
}
