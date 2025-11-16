import 'package:flutter/painting.dart';

class MImagePayload {
  final String? imagePath;
  final String? errorImage;
  final double? height, width;
  final BoxFit? fit;
  final bool? isCircular, isProfileImage;

  MImagePayload({
    this.errorImage,
    this.fit,
    this.height,
    this.imagePath,
    this.isCircular,
    this.isProfileImage,
    this.width,
  });
}
