import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';

abstract class ISecretDataSource {//
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addSecretNote(MSecret payload);
  Future<void> updateSecretNote(MSecret payload);
  Future<void> deteteSecretNote(String id);
  Future<List<MSecret>> fetchSecretNote(MSQuery payload);
}
