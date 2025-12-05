import 'package:daily_info/features/profile/view/secret/data/datasource/passkey/passkey_datasource.dart';
import 'package:daily_info/features/profile/view/secret/data/datasource/secret_note/secret_note_datasource.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';
import 'package:daily_info/features/profile/view/secret/data/repository/secret_note/secret_note_repository.dart';

class SecretRepositoryImpl extends ISecretRepository {
  final ISecretDataSource _iSecretDataSource;
  SecretRepositoryImpl(this._iSecretDataSource);

  @override
  Future<void> addSecretNote(MSecret payload) async {
    return _iSecretDataSource.addSecretNote(payload);
  }

  @override
  Future<void> deteteSecretNote(String id) async {
    return _iSecretDataSource.deteteSecretNote(id);
  }

  @override
  Future<List<MSecret>> fetchSecretNote(MSQuery payload) async {
    return _iSecretDataSource.fetchSecretNote(payload);
  }

  @override
  Future<void> updateSecretNote(MSecret payload) async {
    return _iSecretDataSource.updateSecretNote(payload);
  }
}
