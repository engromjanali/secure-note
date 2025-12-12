import '../data_source/patient_data_source.dart';
import '../models/m_profile.dart';
import 'patient_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileData _profileDataSource;
  ProfileRepositoryImpl(IProfileData profileData)
    : _profileDataSource = profileData;

  @override
  Future<MProfile> fetchProfile() async {
    final res = await _profileDataSource.fetchProfile();
    return res;
  }

  @override
  Future<MProfile> updateProfile(MProfile payload) async {
    final res = await _profileDataSource.updateProfile(payload);
    return res;
  }
  @override
  Future<MProfile> changeSessionKey(MProfile payload) async {
    final res = await _profileDataSource.changeSessionKey(payload);
    return res;
  }
}
