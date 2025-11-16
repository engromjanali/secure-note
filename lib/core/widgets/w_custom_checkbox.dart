import 'package:flutter/material.dart';

class WCustomcheckBox extends StatelessWidget {
  final EdgeInsets pad;
  final double scale;
  final bool value;
  final Color fill;
  final Color activeColor;
  final Function(bool)? onTap;
  const WCustomcheckBox({
    super.key,
    this.pad = const EdgeInsets.all(2),
    this.scale = 1,
    required this.value,
    this.onTap,
    this.fill = Colors.blue,
    this.activeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Padding(
        padding: pad,
        child: GestureDetector(
          onTap: onTap == null
              ? null
              : () {
                  onTap?.call(!value);
                },
          child: Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: value ? fill : null,
              border: value
                  ? null
                  : Border.all(color: fill, style: BorderStyle.solid, width: 2),
            ),
            child: value
                ? Center(
                    child: Icon(
                      Icons.check,
                      color: activeColor,
                      size: 14,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
