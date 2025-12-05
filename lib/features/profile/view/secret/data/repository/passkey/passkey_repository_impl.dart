import 'package:daily_info/features/profile/view/secret/data/datasource/passkey/passkey_datasource.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/repository/passkey/passkey_repository.dart';

class PasskeyRepositoryImpl extends IPasskeyRepository {
  final IPasskeyDataSource _iPasskeyDataSource;
  PasskeyRepositoryImpl(this._iPasskeyDataSource);

  @override
  Future<void> addPasskey(MPasskey payload) async {
    return _iPasskeyDataSource.addPasskey(payload);
  }

  @override
  Future<void> detetePasskey(String id) async {
    return _iPasskeyDataSource.detetePasskey(id);
  }

  @override
  Future<List<MPasskey>> fetchPasskey(MSQuery payload) async {
    return _iPasskeyDataSource.fetchPasskey(payload);
  }

  @override
  Future<void> updatePasskey(MPasskey payload) async {
    return _iPasskeyDataSource.updatePasskey(payload);
  }
}
