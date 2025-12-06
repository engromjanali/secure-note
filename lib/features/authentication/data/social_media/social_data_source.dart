import 'package:secure_note/features/authentication/data/model/m_token.dart';

abstract class ISocialAuthService {
  Future<MToken> authenticate();
}
