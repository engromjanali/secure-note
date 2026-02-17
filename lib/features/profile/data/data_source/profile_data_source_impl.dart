import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import '../../../../core/constants/env.dart';
import '../../../../../core/services/dio_service.dart';
import '../models/m_profile.dart';
import 'patient_data_source.dart';

class ProfileDataSourceImpl extends ENV implements IProfileData {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MProfile> fetchProfile() async {
    final user = firebaseAuth.currentUser;
    final docRef = FirebaseFirestore.instance
        .collection(PKeys.users)
        .doc(user?.uid);

    final doc = await docRef.get();
    return MProfile.fromJson(Map<String, dynamic>.from(doc.data() ?? {}));
  }

  @override
  Future<String> uploadProfileImage(String imagePath, String uId) async {
    String path = "/v1_1/dskavcx9z/image/upload";
    if (isNull(imagePath) || isNull(uId)) {
      throw "Argument can't be null";
    }
    final FormData data = FormData.fromMap({
      if (isNotNull(imagePath))
        'file': await MultipartFile.fromFile(imagePath, filename: uId,),
      'upload_preset': "secure_note",
      "asset_folder": "secure_note",
      "public_id": uId,
    });
    final res = await makeRequest(
      path: path,
      method: HTTPMethod.post,
      data: data,
    );
    return (res.data["secure_url"]);
  }

  @override
  Future<MProfile> updateProfile(MProfile payload) async {
    bool uploadImage = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw "You Are Not Signed!";
    }
    final docRef = FirebaseFirestore.instance
        .collection(PKeys.users)
        .doc(user.uid);

    if (isNotNull(payload.image) && isNotNull(payload.id)) {
      try {
        // given image local image path
        String image = await uploadProfileImage(payload.image!, payload.id!);
        // these image claude-stored/network image path,
        payload.image = image;
      } catch (e) {
        uploadImage = false;
        errorPrint("Error image was not upload: $e");
      }
    }
    await docRef.set(
      payload.toJson(),
      SetOptions(
        mergeFields: ["name", if (uploadImage) "image", "updatedAt"],
      ), // infuture we will add email,
    );
    return await fetchProfile();
  }

  @override
  Future<MProfile> changeSessionKey(MProfile payload) async {
    if (isNull(payload.id)) {
      throw "user-id can't be null";
    }
    final user = firebaseAuth.currentUser;
    final docRef = FirebaseFirestore.instance
        .collection(PKeys.users)
        .doc(user?.uid);

    // update sessionKey
    await docRef.set(payload.toJson(), SetOptions(mergeFields: ["sessionKey"]));
    // get updated data.
    final doc = await docRef.get();
    if (isNull(doc.data())) {
      throw "Somthing Want Wrong";
    }
    return MProfile.fromJson(Map<String, dynamic>.from(doc.data()!));
  }
}
