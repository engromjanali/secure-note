import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CImagePicker {
  CImagePicker._();
  static final CImagePicker _instance = CImagePicker._();
  factory CImagePicker() => _instance;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickSingleImage({
    ImageSource choseFrom = ImageSource.gallery,
  }) async {
    // remember picked image is a file so we can't treat it as asset,
    // treat as file,
    // Image.file(File(_pickedFile!.path))

    XFile? pickedFile = await _picker.pickImage(source: choseFrom);
    return pickedFile;
  }

  Future<List<XFile>?> pickMultipleImage({limit = 20}) async {
    // iOS 14+ limit work
    // min limit: 2 otherwise we get an error
    List<XFile> pickedFileList = await _picker.pickMultiImage(limit: limit);
    return pickedFileList.take(limit).toList();
  }

  Future<List<XFile>?> getLostData() async {
    if (!Platform.isAndroid) {
      return null; // may we lost data only android devices.
    }
    LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) return null;
    debugPrint("lost image found");

    if (response.files != null && response.files!.isNotEmpty) {
      return response.files;
    } else {
      debugPrint("Error: ${response.exception}");
    }
    return null;
  }
}
