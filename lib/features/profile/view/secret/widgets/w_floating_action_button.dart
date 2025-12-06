import 'package:another_flushbar/flushbar.dart';
import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/w_container.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/profile/view/secret/view/s_add_passkey.dart';
import 'package:secure_note/features/profile/view/secret/widgets/w_select_note_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WFloatingActionButton extends StatefulWidget {
  Function(int)? onTap;
  WFloatingActionButton({super.key, this.onTap});

  @override
  State<WFloatingActionButton> createState() => _WFloatingActionButtonState();
}

class _WFloatingActionButtonState extends State<WFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fabAnimation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fabAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiFab();
  }

  Widget _buildMultiFab() {
    return SizedBox(
      height: 180.h,
      width: 100.w,
      child: Stack(
        alignment: Alignment.centerRight,
        clipBehavior: Clip.none,
        children: [
          // 🟢 FAB 1
          Positioned(
            right: 10,
            bottom: 130,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _WActionButton(
                  iconData: Icons.key,
                  label: "Passkey",
                  onTap: () {
                    widget.onTap?.call(2);
                  },
                ),
              ),
            ),
          ),

          // 🔵 FAB 2
          Positioned(
            bottom: 75,
            right: 10,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _WActionButton(
                  iconData: Icons.note_alt_outlined,
                  label: "Note",
                  onTap: () {
                    widget.onTap?.call(1);
                  },
                ),
              ),
            ),
          ),

          // ⚫ Main FAB
          Positioned(
            bottom: 20,
            right: 10,
            child: _WActionButton(
              onTap: () {
                _toggle();
              },
              iconData: _isOpen ? Icons.close : Icons.add_task_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _WActionButton extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  final double size;
  final double iconSize;
  final String? label;
  const _WActionButton({
    super.key,
    this.onTap,
    required this.iconData,
    this.size = 50,
    this.iconSize = 30,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isNotNull(label))
            WContainer(
              horizontalPadding: 5,
              verticalPadding: 5,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.blue),
              //   borderRadius: BorderRadius.circular(PTheme.borderRadius),
              // ),
              child: Text(label!).pH(),
            ).pR(),
          Container(
            height: size.r,
            width: size.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: PColors.primaryButtonColorDark,
            ),
            child: Icon(iconData, size: iconSize.r),
          ),
        ],
      ),
    );
  }
}
