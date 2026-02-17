import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/widgets/w_container.dart';
import 'package:secure_note/core/widgets/w_shimmer.dart';

class WAppsShimmer extends StatelessWidget {
  const WAppsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return WContainer(
      borderColor: Colors.transparent,
      borderRadius: 12.r,
      boxShadow: [
        BoxShadow(
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(1, 2),
          color:  (context.textTheme?.titleMedium?.color??Colors.black).withValues(alpha: 0.08),
        ),
      ],
      child: Row(
        children: [
          // Left shimmer image
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 48.h,
                width: 48.w,
                color: Colors.grey.shade300,
              ),
            ),
          ).pR(value: 16),

          // Text shimmer blocks
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 12.h,
                  width: 100.w,
                  color: Colors.grey.shade300,
                ),
              ).pB(value: 6),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 10.h,
                  width: 60.w,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
