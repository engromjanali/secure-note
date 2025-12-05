import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/core/constants/keys.dart';
import 'package:daily_info/features/profile/data/models/m_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data_source/auth_data_source.dart';
import '../model/m_auth.dart';
import '../model/m_social_auth_model.dart';
import '../model/m_token.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  AuthRepositoryImpl(IAuthDataSource authDataSource)
    : _authDataSource = authDataSource;

  @override
  Future<MToken> signInWithEmailAndPassword(MAuth payload) async {
    return await _authDataSource.signInWithEmailAndPass(payload);
  }

  @override
  Future<MToken> signUpWithEmailAndPassword(MAuth payload) async {
    return await _authDataSource.registerWithEmailAndPass(payload);
  }

  // @override
  // Future<MToken?> loginWithSocial(MSocialAuth auth) async {
  //   return await _authDataSource.loginWithSocial(auth);
  // }
}
