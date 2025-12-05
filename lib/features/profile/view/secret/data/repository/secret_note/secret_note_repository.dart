import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';


abstract class ISecretRepository {
  Future<void> addSecretNote(MSecret payload);
  Future<void> updateSecretNote(MSecret payload);
  Future<void> deteteSecretNote(String id);
  Future<List<MSecret>> fetchSecretNote(MSQuery payload);
}
