import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';

abstract class IPasskeyDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addPasskey(MPasskey payload);
  Future<void> updatePasskey(MPasskey payload);
  Future<void> detetePasskey(String id);
  Future<List<MPasskey>> fetchPasskey(MSQuery payload);
}
