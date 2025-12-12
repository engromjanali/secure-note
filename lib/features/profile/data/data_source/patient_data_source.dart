import '../models/m_profile.dart';

abstract class IProfileData {
  Future<MProfile> fetchProfile();
  Future<MProfile> updateProfile(MProfile payload);
  Future<MProfile> changeSessionKey(MProfile payload);
}
