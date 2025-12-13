import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/features/authentication/data/model/m_token.dart';
import 'package:secure_note/features/profile/data/models/m_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/functions/f_printer.dart';
import 'social_data_source.dart';

class GoogleAuthService implements ISocialAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _initialize() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  @override
  Future<MToken> authenticate() async {
    await _initialize();

    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Add additional scopes if needed
      );
    } on GoogleSignInException catch (e) {
      errorPrint('Google Sign-In error: ${e.code} - ${e.description}');
      rethrow;
    } catch (e) {
      errorPrint('Unexpected error during Google authenticate(): $e');
      rethrow;
    }
    printer("google user");

    final googleAuth = googleUser.authentication; // Now synchronous
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );

    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      await createUserIfNotExists(googleUser);

      return MToken(userCredential: userCredential);
    } catch (e) {
      errorPrint('Firebase signInWithCredential failed: $e');
      rethrow;
    }
  }

  Future<void> createUserIfNotExists(GoogleSignInAccount googleUser) async {
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
        name: googleUser.displayName,
        email: googleUser.email,
        image: googleUser.photoUrl,
        sessionKey: Random().nextInt(9999).toString(),
        createdAt: DateTime.timestamp(),
        updatedAt: DateTime.timestamp(),
      );
      await docRef.set(payload.toJson());
      printer("🔥 New user created in Firestore");
    } else {
      printer("⚡ User already exists");
    }
  }
}
