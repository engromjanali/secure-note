import 'package:daily_info/features/authentication/data/model/m_token.dart';

abstract class ISocialAuthService {
  Future<MToken> authenticate();
}
