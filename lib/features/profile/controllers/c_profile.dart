import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_loader.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/flutter_secure_service.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/features/profile/data/models/m_profile_update_payload.dart';
import 'package:daily_info/features/s_home.dart';
import 'package:daily_info/spalsh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_state/power_state.dart';
import '../../../../core/controllers/c_base.dart';
import '../../../../core/services/shared_preference_service.dart';
import '../data/models/m_profile.dart';
import '../data/repository/patient_repository.dart';

class CProfile extends CBase {
  final IProfileRepository _profileRepository;
  CProfile(IProfileRepository profileRepository)
    : _profileRepository = profileRepository;

  MProfile mProfileData = MProfile();
  String? hash;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool get isSigned => isNotNull(firebaseAuth.currentUser);
  // functions
  Future getPatientList() async {
    printer("getPatientList");
    try {
      mProfileData = await _profileRepository.fetchProfile();
      printer(mProfileData.toJson());
    } catch (e, s) {
      setException(error: e, stackTrace: s);
    } finally {
      update();
    }
  }

  Future editPrifle(MProfileUpdatePayload payload) async {
    try {
      showLoader();
      mProfileData = await _profileRepository.updateProfile(payload);
      hideOverlay();
      Future.microtask(() => hideOverlay());
    } catch (e, s) {
      hideOverlay();
      setException(error: e, stackTrace: s);
    } finally {
      update();
    }
  }

  Future<void> logOut() async {
    // SharedPrefService.instance.clear();
    firebaseAuth.signOut();
    mProfileData = MProfile();
    update();
    await FSSService().clear();
    PowerVault.delete<CProfile>();
    SpalshScreen().pushAndRemoveUntil();
  }
}
