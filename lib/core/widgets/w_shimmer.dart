import 'package:flutter/material.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  });

  /// Factory for easier usage with base + highlight colors
  factory Shimmer.fromColors({
    Key? key,
    required Widget child,
    required Color baseColor,
    required Color highlightColor,
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.ltr,
    int loop = 0,
    bool enabled = true,
  }) {
    return Shimmer(
      key: key,
      period: period,
      direction: direction,
      loop: loop,
      enabled: enabled,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.centerRight,
        colors: [
          baseColor,
          baseColor,
          highlightColor,
          baseColor,
          baseColor,
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ),
      child: child,
    );
  }

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _count++;
          if (widget.loop <= 0) {
            _controller.repeat();
          } else if (_count < widget.loop) {
            _controller.forward(from: 0.0);
          }
        }
      });

    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Rect _calculateRect(Size size, double percent) {
    final double width = size.width;
    final double height = size.height;

    switch (widget.direction) {
      case ShimmerDirection.rtl:
        return Rect.fromLTWH(
          _offset(width, -width, percent) - width,
          0,
          3 * width,
          height,
        );
      case ShimmerDirection.ttb:
        return Rect.fromLTWH(
          0,
          _offset(-height, height, percent) - height,
          width,
          3 * height,
        );
      case ShimmerDirection.btt:
        return Rect.fromLTWH(
          0,
          _offset(height, -height, percent) - height,
          width,
          3 * height,
        );
      case ShimmerDirection.ltr:
        return Rect.fromLTWH(
          _offset(-width, width, percent) - width,
          0,
          3 * width,
          height,
        );
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            final rect = _calculateRect(bounds.size, _controller.value);
            return widget.gradient.createShader(rect);
          },
          child: child,
        );
      },
    );
  }
}
