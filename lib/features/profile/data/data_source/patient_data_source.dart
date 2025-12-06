import 'package:secure_note/features/profile/data/models/m_profile_update_payload.dart';
import '../models/m_profile.dart';

abstract class IProfileData {
  Future<MProfile> fetchProfile();
  Future<MProfile> updateProfile(MProfileUpdatePayload payload);
}
