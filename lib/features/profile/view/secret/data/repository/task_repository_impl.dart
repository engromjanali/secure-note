import 'package:daily_info/features/profile/view/secret/data/datasource/task_datasource.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';
import 'package:daily_info/features/profile/view/secret/data/repository/task_repository.dart';

class SecretRepositoryImpl extends ISecretRepository {
  final ISecretDataSource _iSecretDataSource;
  SecretRepositoryImpl(this._iSecretDataSource);

  @override
  Future<void> addSecret(MSecret payload) async {
    return _iSecretDataSource.addSecret(payload);
  }

  @override
  Future<void> deteteSecret(String id) async {
    return _iSecretDataSource.deteteSecret(id);
  }

  @override
  Future<List<MSecret>> fetchSecret(MSQuery payload) async {
    return _iSecretDataSource.fetchSecret(payload);
  }

  @override
  Future<void> updateSecret(MSecret payload) async {
    return _iSecretDataSource.updateSecret(payload);
  }
}
