import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';

abstract class ISecretDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addSecret(MSecret payload);
  Future<void> updateSecret(MSecret payload);
  Future<void> deteteSecret(String id);
  Future<List<MSecret>> fetchSecret(MSQuery payload);
}
