import 'dart:io';
import '../w_shimmer.dart';
import 'm_image_payload.dart';
import '/../gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/../core/constants/dimension_theme.dart';
import '/./core/extensions/ex_build_context.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 🖼️ WImage
/// A flexible image widget that:
/// ✅ Loads from network
/// 🔄 Shows loading spinner while fetching
/// 🚨 Displays fallback image on error
/// 🔵 Can be shown in a circular frame with [isCircular]
/// 📐 Respects [height], [width], and [fit] for layout.
class WImage extends StatelessWidget {
  final String? imageUrl;
  final MImagePayload? payload;

  const WImage(this.imageUrl, {super.key, this.payload});

  bool _isNetworkUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith("http://") || url.startsWith("https://");
  }

  bool _isFileUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith("file://") || url.startsWith("/");
  }

  @override
  Widget build(BuildContext context) {
    final double finalHeight = payload?.height ?? PTheme.imageDefaultX;
    final double finalWidth = payload?.width ?? PTheme.imageDefaultX;

    Widget imageWidget;

    if (_isNetworkUrl(imageUrl)) {
      // 🌐 Load from network with caching + shimmer placeholder
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        height: finalHeight,
        width: finalWidth,
        fit: payload?.fit ?? BoxFit.cover,
        placeholder: (context, url) => _WShimmerPlaceholder(
          width: finalWidth,
          height: finalHeight,
          isCircular: false,
        ),
        errorWidget: (context, url, error) => _WFallbackImage(payload),
      );
    } else if (_isFileUrl(imageUrl)) {
      // 📂 Load from local file
      imageWidget = Image.file(
        File(imageUrl!.replaceFirst("file://", "")),
        height: finalHeight,
        width: finalWidth,
        fit: payload?.fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _WFallbackImage(payload),
      );
    } else {
      // ❌ Invalid/empty url
      imageWidget = _WFallbackImage(payload);
    }

    // 🔵 Optional: Circular crop
    if (payload?.isCircular == true) {
      return ClipOval(
        child: SizedBox(
          height: finalHeight,
          width: finalWidth,
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }
}

class _WShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircular;

  const _WShimmerPlaceholder({
    required this.width,
    required this.height,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: isCircular
              ? BorderRadius.circular(width / 2)
              : BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _WFallbackImage extends StatelessWidget {
  final MImagePayload? payload;

  const _WFallbackImage(this.payload);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      payload?.isProfileImage == true
          ? Assets.logo.profile
          : Assets.logo.imageNotFound,
      height: payload?.height ?? PTheme.imageDefaultY,
      width: payload?.width ?? PTheme.imageDefaultX,
      fit: payload?.fit ?? BoxFit.cover,
      colorFilter: ColorFilter.mode(context.primaryTextColor!, BlendMode.srcIn),
    );
  }
}
