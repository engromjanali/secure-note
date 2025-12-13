import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/functions/f_encrypt_decrypt.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/secret_note/secret_note_datasource.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:power_state/power_state.dart';

class SecretDatasourceImpl extends ISecretDataSource {
  CProfile cProfile = PowerVault.find<CProfile>();
  @override
  Future<void> addSecretNote(MSecret payload) async {
    await firebaseFirestore
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .doc(payload.id)
        .set(encrypt(payload.toMap()));
  }

  @override
  Future<void> deteteSecretNote(String id) async {
    await firebaseFirestore
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .doc(id)
        .delete();
  }

  @override
  Future<List<MSecret>> fetchSecretNote(MSQuery payload) async {
    List<MSecret> list = [];
    Query query = FirebaseFirestore.instance
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .orderBy("id", descending: true);

    if ((payload.isLoadNext ?? true) && isNotNull(payload.lastEid)) {
      query = query
          .startAfter([payload.lastEid])
          .limit(payload.limit ?? PDefaultValues.limit);
    } else if (!(payload.isLoadNext ?? true) && isNotNull(payload.firstEid)) {
      query = query
          .endBefore([payload.firstEid])
          .limitToLast(payload.limit ?? PDefaultValues.limit);
    }
    if (isNull(payload.firstEid) && isNull(payload.lastEid)) {
      query = query.limit(payload.limit!);
    }

    await query.get().then((querySnapshot) {
      // Append the new documents to your existing list...
      if (querySnapshot.docs.isNotEmpty) {
        list = querySnapshot.docs
            .map(
              (e) => MSecret.fromMap(decrypt(e.data() as Map<String, dynamic>)),
            )
            .toList();
      }
    });
    list.map((e) {
      printer(e.toMap());
      return e;
    }).toList();
    return list;
  }

  @override
  Future<void> updateSecretNote(MSecret payload) async {
    return firebaseFirestore
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .doc(payload.id)
        .update(encrypt(payload.toMap()));
  }
}
