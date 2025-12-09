import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/functions/f_encrypt_decrypt.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/passkey/passkey_datasource.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:power_state/power_state.dart';

class PasskeyDataSourceImpl extends IPasskeyDataSource {
  CProfile cProfile = PowerVault.find<CProfile>();

  @override
  Future<void> addPasskey(MPasskey payload) async {
    printer("addPasskey data source ${payload.toString()}");
    await firebaseFirestore
        .collection(PKeys.passkey)
        .doc(cProfile.mProfileData.id)
        .collection(PKeys.passkey)
        .doc(payload.id)
        .set(encrypt(payload.toMap()));
  }

  @override
  Future<void> detetePasskey(String id) async {
    printer("trying to delete $id");
    await firebaseFirestore
        .collection(PKeys.passkey)
        .doc(cProfile.mProfileData.id)
        .collection(PKeys.passkey)
        .doc(id)
        .delete();
  }

  @override
  Future<List<MPasskey>> fetchPasskey(MSQuery payload) async {
    List<MPasskey> list = [];
    Query query = FirebaseFirestore.instance
        .collection(PKeys.passkey)
        .doc(cProfile.mProfileData.id)
        .collection(PKeys.passkey)
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
              (e) =>
                  MPasskey.fromMap(decrypt(e.data() as Map<String, dynamic>)),
            )
            .toList();
      }
    });
    return list;
  }

  @override
  Future<void> updatePasskey(MPasskey payload) async {
    return firebaseFirestore
        .collection(PKeys.passkey)
        .doc(cProfile.mProfileData.id)
        .collection(PKeys.passkey)
        .doc(payload.id)
        .update(encrypt(payload.toMap()));
  }
}
