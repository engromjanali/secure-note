import 'package:daily_info/features/profile/data/models/m_profile_update_payload.dart';
import '../models/m_profile.dart';

abstract class IProfileRepository {
  Future<MProfile> fetchProfile();
  Future<MProfile> updateProfile(MProfileUpdatePayload payload);
}
