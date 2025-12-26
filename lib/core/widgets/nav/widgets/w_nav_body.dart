import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/m_nav_bar_item.dart';
import 'package:vector_math/vector_math_64.dart';

class WBody extends StatelessWidget {
  const WBody({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.curve,
    required this.duration,
    required this.onTap,
  });

  final List<MNavBarItem> items;
  final int currentIndex;
  final Curve curve;
  final Duration duration;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final item in items)
          Builder(
            builder: (_) {
              final index = items.indexOf(item);
              bool isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap.call(index),
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  transform: Matrix4.diagonal3(
                    Vector3(
                      isSelected ? 1.2 : 1.0, // x scale - wider
                      isSelected ? 1.2 : 1.0, // y scale - height
                      1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        isSelected ? item.icon : item.unSelectedIcon,
                        height: 25.w,
                        width: 25.w,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? context.primaryTextColor!
                              : const Color.fromARGB(255, 78, 76, 76),
                          // : context.theme.brightness == Brightness.dark
                          // ? PColors.secondaryTextColorDark
                          // : PColors.secondaryTextColorLight,
                          BlendMode.srcIn,
                        ),
                      ),

                      if (isNotNull(item.title))
                        Text(
                          item.title!,
                          style: context.textTheme?.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Custom",
                          ),
                        ),
                    ],
                  ),
                ).pV(),
              );
            },
          ),
      ],
    );
  }
}
