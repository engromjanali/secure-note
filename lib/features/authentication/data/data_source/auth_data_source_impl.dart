import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/core/constants/keys.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/features/profile/data/models/m_profile.dart';
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
        image: null,
        createdAt: DateTime.timestamp(),
        updatedAt: DateTime.timestamp(),
      );
      await docRef.set(payload.toJson());
      print("🔥 New user created in Firestore");
    } else {
      print("⚡ User already exists");
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
