import 'package:daily_info/core/constants/default_values.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:daily_info/core/functions/f_url_launcher.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/features/profile/view/s_faq.dart';
import 'package:daily_info/features/profile/view/secret/view/s_secondary_auth.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        onConfirm: () {
          showSnackBar("History Cleared");
        },
      );
    },
  ),
  MSItem(
    icon: Assets.icons.vault,
    label: "Secret Vault",
    onTap: () {
      SSAuth().push();
    },
  ),
];

List<MSItem> menuList = [
  MSItem(
    icon: Assets.icons.restorePurchase,
    label: "Restore Purchase",
    onTap: () {
      showSnackBar("Under build");
    },
  ),
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
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.privacyAndPolicy,
    label: "Privacy Policy",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.profile,
    label: "User ID",
    onTap: () {
      Clipboard.setData(ClipboardData(text: "483nvidfn10238593"));
      showSnackBar("Copyed!");
    },
    child: _WCopyButton(),
  ),
];

class _WCopyButton extends StatelessWidget {
  const _WCopyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "483nvidfn10238593",
            style: context.textTheme?.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.file_copy, color: context.primaryTextColor),
      ],
    );
  }
}
