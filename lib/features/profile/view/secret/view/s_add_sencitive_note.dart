import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_copy_to_clipboard.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:daily_info/core/widgets/w_bottom_nav_button.dart';
import 'package:daily_info/core/widgets/w_card.dart';
import 'package:daily_info/core/widgets/w_text_field.dart';
import 'package:flutter/material.dart';

class SASNote extends StatelessWidget {
  final bool viewOnly;
  GlobalKey<FormState> fromKey = GlobalKey();
  ValueNotifier<List<String>> backupCodeListeners = ValueNotifier([]);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController backupController = TextEditingController();
  SASNote({super.key, this.viewOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              spacing: PTheme.paddingY,
              children: [
                WTextField.requiredField(
                  enable: !viewOnly,
                  label: "Title",
                  controller: titleController,
                ),
                WTextField(
                  enable: !viewOnly,
                  label: "Password",
                  controller: passController,
                ),
                BackupCodeWapper("Backup Codes", context, backupCodeListeners),
                if (!viewOnly)
                  WTextField(
                    enable: !viewOnly,
                    label: "Backup Code",
                    hintText: "xxxxxxx xxxxxx xxxxxx\nxxxxxxx xxxxxx",
                    minLines: 2,
                    maxLines: 5,
                    controller: backupController,
                    suffixIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (backupController.text.isNotEmpty) {
                              backupCodeListeners.value = backupController.text
                                  .trim()
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .split(" ");
                            } else {
                              backupCodeListeners.value = [];
                            }
                          },
                          icon: Icon(
                            Icons.sync,
                            color: context.button?.primary,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                WTextField(
                  enable: !viewOnly,
                  label: "Note",
                  // controller: backupController,
                  maxLines: 6,
                  minLines: 1,
                ),
                gapY(50),
                if (!viewOnly) WBottomNavButton(label: "Submit", ontap: submit),
              ],
            ).pAll(),
          ),
        ),
      ),
    );
  }

  void submit() {
    if (fromKey.currentState?.validate() ?? false) {}
  }
}

Widget BackupCodeWapper(
  String label,
  BuildContext context,
  ValueNotifier<List<String>> list,
) => Column(
  spacing: PTheme.spaceY,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: context.textTheme?.labelMedium),
    WCard(
      child: ValueListenableBuilder(
        valueListenable: list,
        builder: (context, values, child) {
          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 50,
              crossAxisSpacing: 10,
            ),
            itemCount: values.length,
            itemBuilder: (context, index) {
              return WBCode(
                onTap: () {
                  copyToClipBoard(values[index]);
                  showSnackBar("copyed");
                },
                serial: index + 1,
                code: values[index],
                mainAxisAlignment: index % 2 == 1
                    ? MainAxisAlignment.end
                    : null,
              );
            },
          ).pAll();
        },
      ),
    ),
  ],
);

class WBCode extends StatelessWidget {
  final Function()? onTap;
  final int? serial;
  final String? code;
  final MainAxisAlignment? mainAxisAlignment;
  const WBCode({
    super.key,
    required this.onTap,
    this.serial,
    this.code,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        spacing: PTheme.spaceX,
        children: [
          Text(
            "${serial?.toString() ?? PDefaultValues.noFee}.",
            style: context.textTheme?.titleSmall,
          ),
          Text(
            code ?? PDefaultValues.noName,
            style: context.textTheme?.titleSmall,
            overflow: TextOverflow.ellipsis,
          ).expd(),
          Icon(
            Icons.copy,
            size: context.textTheme?.titleSmall?.fontSize,
            color: context.button?.primary,
          ),
        ],
      ),
    );
  }
}
