import '../model/m_auth.dart';
import '../model/m_token.dart';

abstract class IAuthDataSource {
  Future<MToken> registerWithEmailAndPass(MAuth payload);
  Future<MToken> signInWithEmailAndPass(MAuth payload);
  // Future<MToken?> loginWithSocial(MSocialAuth auth);
}
