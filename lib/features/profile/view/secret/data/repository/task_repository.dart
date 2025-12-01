import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';


abstract class ISecretRepository {
  Future<void> addSecret(MSecret payload);
  Future<void> updateSecret(MSecret payload);
  Future<void> deteteSecret(String id);
  Future<List<MSecret>> fetchSecret(MSQuery payload);
}
