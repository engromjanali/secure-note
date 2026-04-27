import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/features/authentication/data/model/m_token.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'social_data_source.dart';

class AppleAuthService implements ISocialAuthService {
  @override
  Future<MToken> authenticate() async {
    // to implement sign-in with apple we need a paid apple developer account,
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      oauthCredential,
    );
    final user = userCredential.user;

    String? email = user?.email ?? appleCredential.email;
    String? firstName = appleCredential.givenName;
    String? lastName = appleCredential.familyName;

    return MToken(userCredential: userCredential);
  }
}
