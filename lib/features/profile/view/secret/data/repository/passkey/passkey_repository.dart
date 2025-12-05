import 'package:daily_info/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';


abstract class IPasskeyRepository {
  Future<void> addPasskey(MPasskey payload);
  Future<void> updatePasskey(MPasskey payload);
  Future<void> detetePasskey(String id);
  Future<List<MPasskey>> fetchPasskey(MSQuery payload);
}
