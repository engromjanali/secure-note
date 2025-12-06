import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_state/power_state.dart';
import '../../../core/constants/keys.dart';
import '../../../core/controllers/c_base.dart';
import '../../../core/functions/f_loader.dart';
import '../../../core/services/shared_preference_service.dart';
import '../../../core/widgets/load_and_error/models/view_state_model.dart';
import '../../profile/controllers/c_profile.dart';
import '../../profile/data/data_source/profile_data_source_impl.dart';
import '../../profile/data/repository/patient_repository_impl.dart';
import '../data/social_media/apple_source_impl.dart';
import '../data/social_media/google_auth_source_impl.dart';
import '../data/social_media/social_data_source.dart';
import '../data/model/m_auth.dart';
import '../data/model/m_social_auth_model.dart';
import '../data/model/m_token.dart';
import '../data/repository/auth_repository.dart';

class CAuth extends CBase {
  final IAuthRepository _iAuthRepository;
  CAuth(IAuthRepository iAuthRepository) : _iAuthRepository = iAuthRepository;

  final SharedPrefService _sharedPrefService = SharedPrefService.instance;
  final CProfile _cProfile = PowerVault.put(
    CProfile(ProfileRepositoryImpl(ProfileDataSourceImpl())),
  );

  void updateViewState({ViewState? viewState}) {
    this.viewState = viewState ?? this.viewState;
    notifyListeners();
  }

  Future<void> signIn({required MAuth payload}) async {
    try {
      updateViewState(viewState: ViewState.loading);
      MToken token = await _iAuthRepository.signInWithEmailAndPassword(payload);
      updateViewState(viewState: ViewState.loaded);
      // _sharedPrefService.setString(PKeys.usertoken, token?.token ?? "");
      await _cProfile.getPatientList();
      Navigation.pop();
    } catch (e, s) {
      updateViewState(viewState: ViewState.error);
      setException(error: e, stackTrace: s, setExceptionOnly: true);
    }
  }

  Future<void> signUp({required MAuth payload}) async {
    try {
      updateViewState(viewState: ViewState.loading);
      MToken? token = await _iAuthRepository.signUpWithEmailAndPassword(
        payload,
      );
      updateViewState(viewState: ViewState.loaded);
      // _sharedPrefService.setString(PKeys.usertoken, token?.token ?? "");
      await _cProfile.getPatientList();
      Navigation.pop();
    } catch (e, s) {
      updateViewState(viewState: ViewState.error);
      setException(error: e, stackTrace: s, setExceptionOnly: true);
    }
  }

  Future<void> signInWithSocial(SocialMediaType type) async {
    showLoader();
    try {
      final ISocialAuthService socialAuthService = _getAuthService(type);
      final MToken auth = await socialAuthService.authenticate();
      // _sharedPrefService.setString(PKeys.usertoken, token?.token ?? "");
      await _cProfile.getPatientList();
      Navigation.pop();
      hideOverlay();
      // SRoot().pushAndRemoveUntil();
    } catch (e, s) {
      hideOverlay();
      setException(error: e, stackTrace: s, showSnackbar: true);
      // await SharedPrefService.instance.setString(PKeys.usertoken, "");
    }
  }

  ISocialAuthService _getAuthService(SocialMediaType type) {
    switch (type) {
      case SocialMediaType.google:
        return GoogleAuthService();
      case SocialMediaType.apple:
        return AppleAuthService();
      // Add Apple, GitHub, Discord services here
      default:
        throw UnimplementedError("Provider not supported");
    }
  }

  Future<void> sendForgetMail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      errorPrint(e);
    }
  }
}
