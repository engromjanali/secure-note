import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_copy_to_clipboard.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/widgets/w_bottom_nav_button.dart';
import 'package:secure_note/core/widgets/w_button.dart';
import 'package:secure_note/core/widgets/w_card.dart';
import 'package:secure_note/core/widgets/w_text_field.dart';
import 'package:secure_note/features/note/view/s_details.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_passkey.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/passkey/passkey_datasource_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/passkey/passkey_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class SAPasskey extends StatefulWidget {
  final bool viewOnly;
  final bool isEdit;
  final MPasskey? mPasskey;

  SAPasskey({
    super.key,
    this.viewOnly = false,
    this.isEdit = false,
    this.mPasskey,
  });

  @override
  State<SAPasskey> createState() => _SAPasskeyState();
}

class _SAPasskeyState extends State<SAPasskey> {
  GlobalKey<FormState> fromKey = GlobalKey();
  ValueNotifier<List<String>> backupCodeListeners = ValueNotifier([]);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController backupController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  CPasskey cPasskey = PowerVault.put(
    CPasskey(PasskeyRepositoryImpl(PasskeyDataSourceImpl())),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callBackFunction(() {
      printer(widget.mPasskey?.toMap());
      titleController.text = widget.mPasskey?.title ?? "";
      passController.text = widget.mPasskey?.pass ?? "";
      backupController.text = widget.mPasskey?.bCode ?? "";
      noteController.text = widget.mPasskey?.note ?? "";
      syncBCode();
      setState(() {});
    });
  }

  void syncBCode() {
    if (backupController.text.isNotEmpty) {
      backupCodeListeners.value = backupController.text
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ')
          .split(" ");
    } else {
      backupCodeListeners.value = [];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // PowerVault.delete<CPasskey>();
    super.dispose();
  }

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
                  enable: !widget.viewOnly,
                  label: "Title",
                  controller: titleController,
                ),
                WTextField(
                  enable: !widget.viewOnly,
                  label: "Password",
                  controller: passController,
                ),
                BackupCodeWapper("Backup Codes", context, backupCodeListeners),
                if (!widget.viewOnly)
                  WTextField(
                    enable: !widget.viewOnly,
                    label: "Backup Code",
                    hintText: "xxxxxxx xxxxxx xxxxxx\nxxxxxxx xxxxxx",
                    minLines: 2,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    controller: backupController,
                    suffixIcon: Column(
                      mainAxisSize: MainAxisSize.min,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: syncBCode,
                          icon: Icon(
                            Icons.published_with_changes_outlined,
                            color: context.button?.primary,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                WTextField(
                  enable: !widget.viewOnly,
                  label: "Note",
                  controller: noteController,
                  maxLines: 6,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                ),
                gapY(50),
                if (!widget.viewOnly)
                  PowerBuilder<CPasskey>(
                    builder: (cPasskey) => WPrimaryButton(
                      text: "Submit",
                      onTap: submit,
                      isLoading: cPasskey.isLoadingMore,
                    ),
                  ),

                if (widget.viewOnly)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // just to take full size of width,
                      // otherwise we can't saw in left.
                      Row(children: []),
                      Text("Info", style: context.textTheme?.titleSmall),
                      SizedBox.shrink().pDivider().pB(),
                      showDateAsFormated(
                        "Updated At",
                        widget.mPasskey?.updatedAt ??
                            widget.mPasskey?.updatedAt,
                        context: context,
                      ),
                      showDateAsFormated(
                        "Created At",
                        widget.mPasskey?.createdAt ??
                            widget.mPasskey?.createdAt,
                        doNotShowIfNull: false,
                        context: context,
                      ),
                    ],
                  ),
              ],
            ).pAll(),
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (fromKey.currentState?.validate() ?? false) {
      late MPasskey payload;
      if (widget.isEdit) {
        payload = widget.mPasskey!.copyWith(
          title: titleController.text,
          pass: passController.text,
          bCode: backupController.text,
          note: noteController.text,
          updatedAt: DateTime.timestamp(),
        );
      } else {
        payload = MPasskey(
          id: DateTime.timestamp().timestamp,
          title: titleController.text,
          pass: passController.text,
          bCode: backupController.text,
          note: noteController.text,
          createdAt: DateTime.timestamp(),
        );
      }
      await (widget.isEdit
          ? cPasskey.updatePasskey(payload)
          : cPasskey.addPasskey(payload));
      // ALL DONE NOW DELETE THEME.
      titleController.text = "";
      passController.text = "";
      backupController.text = "";
      noteController.text = "";
      backupCodeListeners.value = [];
    }
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
