import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_card.dart';
import 'package:daily_info/core/widgets/w_listtile.dart';
import 'package:daily_info/features/note/view/s_details.dart';
import 'package:flutter/material.dart';

class SNote extends StatefulWidget {
  const SNote({super.key});

  @override
  State<SNote> createState() => _SNoteState();
}

class _SNoteState extends State<SNote> {
  @override
  Widget build(BuildContext context) {
    printer("build");
    return Scaffold(
      appBar: AppBar(title: Text("Nots")),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return WListTile(
            title: "$index",
            fillColor: context.theme.brightness == Brightness.light
                ? PColors.secondaryFillColorLight
                : PColors.secondaryFillColorDark,
            onTap: () {
              SDetails().push();
            },
            index: index,
          );
        },
      ).pAll(),
    );
  }
}
