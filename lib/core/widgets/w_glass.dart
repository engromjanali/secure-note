import 'dart:ui';
import 'package:flutter/material.dart';

class WGlass extends StatelessWidget {
  final BoxBorder? border;
  final EdgeInsets? padding;
  final Widget child;
  final BorderRadius? borderRadius;

  const WGlass({
    super.key,
    this.border,
    this.padding,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
          // tileMode: TileMode.mirror
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white.withAlpha(50),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

// import 'dart:ui';
// import 'package:flutter/material.dart';

// class GlassBackground extends StatelessWidget {
//   final Widget? child;
//   final double blur;
//   final double opacity;
//   final BorderRadius? borderRadius;
//   final Color? color;
//   final EdgeInsets? padding;

//   const GlassBackground({
//     super.key,
//     this.child,
//     this.blur = 10.0,
//     this.opacity = 0.2,
//     this.borderRadius,
//     this.color,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius ?? BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//         child: Container(
//           padding: padding ?? const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: (color ?? Colors.white).withOpacity(opacity),
//             borderRadius: borderRadius ?? BorderRadius.circular(16),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3),
//               width: 1.2,
//             ),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
