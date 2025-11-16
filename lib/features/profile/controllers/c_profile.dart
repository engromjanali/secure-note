import 'package:daily_info/core/functions/f_loader.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/features/profile/data/models/m_profile_update_payload.dart';
import 'package:power_state/power_state.dart';
import '../../../../core/controllers/c_base.dart';
import '../../../../core/services/shared_preference_service.dart';
import '../data/models/m_profile.dart';
import '../data/repository/patient_repository.dart';

class CProfile extends CBase {
  final IProfileRepository _profileRepository;
  CProfile(IProfileRepository profileRepository)
    : _profileRepository = profileRepository;
  MProfile? mProfileData = MProfile();

  // functions
  Future getPatientList() async {
    try {
      mProfileData = await _profileRepository.fetchProfile();
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
    SharedPrefService.instance.clear();
    PowerVault.delete<CProfile>();
    // SSignIn().pushAndRemoveUntil();
  }
}
