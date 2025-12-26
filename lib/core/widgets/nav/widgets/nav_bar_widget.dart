import 'package:flutter/material.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import '../models/m_nav_bar_item.dart';
import 'w_nav_body.dart';

class WNavigationBar extends StatelessWidget {
  final List<MNavBarItem> items;
  final int currentIndex;
  final Duration duration;
  final Curve curve;
  final Function(int index)? onChanged;

  const WNavigationBar({
    super.key,
    required this.items,
    this.curve = Curves.ease,
    required this.currentIndex,
    this.duration = const Duration(milliseconds: 500),
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: PTheme.spaceY),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(16.r),
        //   topRight: Radius.circular(16.r),
        // ),
        // border: Border(
        //   top: BorderSide(
        //     color: context.theme.brightness == Brightness.dark
        //         ? Colors.white
        //         : Colors.black.withAlpha(50),
        //   ),
        // ),
        color: context.theme.navigationBarTheme.backgroundColor,
      ),
      child: WBody(
        items: items,
        currentIndex: currentIndex,
        curve: curve,
        duration: duration,
        onTap: onChanged!,
      ),
    );
  }
}
