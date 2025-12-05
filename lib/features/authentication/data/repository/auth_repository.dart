import '../model/m_auth.dart';
import '../model/m_social_auth_model.dart';
import '../model/m_token.dart';

abstract class IAuthRepository {
  Future<MToken> signInWithEmailAndPassword(MAuth payload);
  Future<MToken> signUpWithEmailAndPassword(MAuth payload);
  // Future<MToken> loginWithSocial(MSocialAuth auth);
}
