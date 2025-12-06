import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ❌ WClose
/// A circular close button with gradient styling and shadow.
/// 📌 Default behavior: `Navigator.pop()`
/// 💡 Useful for dismissing dialogs, modals, or custom pop-ups.
class WClose extends StatelessWidget {
  final VoidCallback? onTap;

  const WClose({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 16.r,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.close, color: context.indicatorColor, size: 20.h),
        ),
      ),
    );
  }
}
