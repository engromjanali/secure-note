import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_info/core/constants/keys.dart';
import 'package:daily_info/features/profile/view/secret/data/datasource/task_datasource.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:daily_info/features/profile/view/secret/data/model/m_secret.dart';

class SecretDataSourceImpl extends ISecretDataSource {
  @override
  Future<void> addSecret(MSecret payload) async {
    await firebaseFirestore
        .collection(PKeys.secret)
        .doc(payload.id)
        .set(payload.toMap());
  }

  @override
  Future<void> deteteSecret(String id) async {
    await firebaseFirestore.collection(PKeys.secret).doc(id).delete();
  }

  @override
  Future<List<MSecret>> fetchSecret(MSQuery payload) async {
    Query nextQuery = FirebaseFirestore.instance
        .collection(PKeys.secret)
        .orderBy(FieldPath.documentId, descending: true)
        .startAfter([payload.lastEid])
        .limit(payload.limit ?? 10);
    nextQuery.get().then((querySnapshot) {
      // Append the new documents to your existing list...
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((e) => MSecret.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    });
    return [];
  }

  @override
  Future<void> updateSecret(MSecret payload) async {
    return firebaseFirestore
        .collection(PKeys.secret)
        .doc(payload.id)
        .update(payload.toMap());
  }
}
