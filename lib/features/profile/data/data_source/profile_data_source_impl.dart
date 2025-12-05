import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/core/constants/keys.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/features/profile/data/models/m_profile_update_payload.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<MProfile> updateProfile(MProfileUpdatePayload payload) async {
    if (isNull(payload.id)) {
      throw "user-id can't be null";
    }
    final FormData data = FormData.fromMap({
      if (!isNull(payload.image))
        'image': await MultipartFile.fromFile(
          payload.image ?? "",
          filename: payload.image,
        ),
      'name': payload.name,
      'email': payload.email,
      if (!isNull(payload.password))
        'password':
            payload.password, // otherwise pass will be change even we send null
    });
    final res = await makeRequest(
      path: payload.id.toString(),
      method: HTTPMethod.patch,
      data: data,
    );
    return MProfile.fromJson(res.data["data"]);
  }
}
