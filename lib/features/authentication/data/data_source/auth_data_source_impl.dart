import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/dio_service.dart';
import 'package:secure_note/features/profile/data/models/m_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/m_auth.dart';
import '../model/m_token.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements IAuthDataSource {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<MToken> registerWithEmailAndPass(MAuth payload) async {
    printer(payload.toJson());
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(
          email: payload.email!,
          password: payload.password!,
        );
    await saveUserData(payload);
    return MToken(userCredential: userCredential);
  }

  @override
  Future<String> uploadProfileImage(String imagePath, String uId) async {
    String path = "/v1_1/dskavcx9z/image/upload";
    if (isNull(imagePath) || isNull(uId)) {
      throw "Argument can't be null";
    }
    final FormData data = FormData.fromMap({
      if (isNotNull(imagePath))
        'file': await MultipartFile.fromFile(imagePath, filename: uId),
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

  Future<void> saveUserData(MAuth data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection(PKeys.users)
        .doc(user.uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      // If user doesn't exist → create
      MProfile payload = MProfile(
        id: user.uid,
        name: data.name,
        email: data.email,
        image: data.image,
        sessionKey: Random().nextInt(9999).toString(),
        createdAt: DateTime.timestamp(),
        updatedAt: DateTime.timestamp(),
      );

      if (isNotNull(payload.image) && isNotNull(payload.id)) {
        // given image local image path
        String image = await uploadProfileImage(payload.image!, payload.id!);
        // these image claude-stored/network image path,
        payload.image = image;
      }
      await docRef.set(payload.toJson());
      printer("🔥 New user created in Firestore");
    } else {
      printer("⚡ User already exists");
    }
  }

  @override
  Future<MToken> signInWithEmailAndPass(MAuth payload) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(
          email: payload.email!,
          password: payload.password!,
        );
    return MToken(userCredential: userCredential);
  }
}
