import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/controllers/c_base.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/secret_note/secret_note_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class CSecret extends CBase {
  final ISecretRepository _iSecretRepository;
  CSecret(this._iSecretRepository);

  List<MSecret> secretList = [];
  final int limit = PDefaultValues.limit;
  String? firstSId;
  String? lastSId;
  bool hasMoreNext = true;
  bool hasMorePrev = false;
  bool isLoadingMore = false;
  bool isLoadNext = true;

  void clear() {
    secretList = [];
    firstSId = null;
    lastSId = null;
    hasMoreNext = true;
    hasMorePrev = false;
    isLoadingMore = false;
  }

  // void listenFundDocChanges({required String messId}) {
  //   fundListener2?.cancel();
  //   try {
  //     fundListener2 = firebaseFirestore
  //         .collection(Constants.fund)
  //         .doc(messId)
  //         .collection(Constants.listOfFundTnx)
  //         .orderBy(Constants.createdAt, descending: true)
  //         .limit(limit)
  //         .snapshots()
  //         .listen((snapshot) {
  //           for (var change in snapshot.docChanges) {
  //             if (change.type == DocumentChangeType.added) {
  //               final data = change.doc.data();
  //               if (data != null) {
  //                 debugPrint('add found');
  //                 final fundModel = FundModel.fromMap(data);
  //                 //Note: fundModel.createdAt == null because firebase firestore send to listener new model before inserting. that's why we can see createdAt == null
  //                 // "listen" at first take few doc. for this moment we are already added by "initialload" function so we did not need to add the that's why we are ignoring the value.
  //                 if (!currentDocs.any((doc) => doc.tnxId == fundModel.tnxId)) {
  //                   currentDocs.insert(0, fundModel); // নতুন  উপরে বসাও
  //                   if (currentDocs.length > limit) {
  //                     currentDocs
  //                         .removeLast(); // because this value will not sync.
  //                   }
  //                   notifyListeners();
  //                 }
  //               }
  //             }
  //             //updated will be visible here if it within the limit. i mean if it exist within the batch, if limit ==10 the doc have to be with the 10 doc.
  //             // at first i set limit and get 10 doc. if i add a new doc last doc will be remove and new doc will be added. but in my array exist the pre value. but we has removed the extra doc menually
  //             // listen has a internal list not my decleared list.
  //             else if (change.type == DocumentChangeType.modified) {
  //               debugPrint("update found");
  //               final data = change.doc.data();
  //               if (data != null) {
  //                 // note in here data load also.
  //                 final updatedModel = FundModel.fromMap(data);
  //                 final index = currentDocs.indexWhere(
  //                   (e) => e.tnxId == updatedModel.tnxId,
  //                 ); // compare by id
  //                 if (index != -1) {
  //                   currentDocs[index] = updatedModel;
  //                   notifyListeners();
  //                 }
  //               }
  //             } else if (change.type == DocumentChangeType.removed) {
  //               debugPrint("delete found");
  //               final data = change.doc.data();
  //               if (data != null) {
  //                 // note in here data load also.
  //                 final removedModel = FundModel.fromMap(data);
  //                 final index = currentDocs.indexWhere(
  //                   (e) => e.tnxId == removedModel.tnxId,
  //                 ); // compare by id
  //                 if (index != -1) {
  //                   currentDocs.removeAt(index);
  //                   notifyListeners();
  //                 }
  //               }
  //             }
  //           }
  //         });
  //   } catch (e) {}
  // }

  Future<void> addSecret(MSecret payload) async {
    try {
      isLoadingMore = true;
      update();
      await _iSecretRepository.addSecretNote(payload);
      showSnackBar("Note Added Successfully.");
      await Future.delayed(Duration(seconds: 2));
      printer(secretList.length);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> updateSecret(MSecret payload) async {
    try {
      isLoadingMore = true;
      update();
      await _iSecretRepository.updateSecretNote(payload);
      showSnackBar("Note Updated.");
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> deleteSecret(String id) async {
    try {
      isLoadingMore = true;
      update();
      printer("delete");
      await _iSecretRepository.deteteSecretNote(id);
      // clear from runtime storage
      secretList.removeWhere((mSecret) => mSecret.id == id);
      showSnackBar("Note Deleted!");
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> fetchSecret({MSQuery? payload}) async {
    secretList.clear();
    await fetchSpacificItem(payload: payload);
  }

  Future<List<MSecret>?> fetchSpacificItem({MSQuery? payload}) async {
    try {
      MSQuery newPayload = MSQuery(
        isLoadNext: payload?.isLoadNext ?? true,
        limit: payload?.limit ?? limit,
        firstEid: payload?.firstEid ?? firstSId,
        lastEid: payload?.lastEid ?? lastSId,
      );
      isLoadNext = payload?.isLoadNext ?? true;

      printer("call 2");
      if (isLoadingMore) {
        return null; //Already loading
      }
      printer("call 3");
      // If loading next AND there are no more next pages, stop.
      if (newPayload.isLoadNext! && !hasMoreNext) {
        return null;
      }
      printer("call 4");
      // If loading previous AND there are no more previous pages, stop.
      if (!newPayload.isLoadNext! && !hasMorePrev) {
        printer("load prev failed");
        return null;
      }
      printer("call 5");
      isLoadingMore = true;
      update();
      List<MSecret> res = await _iSecretRepository.fetchSecretNote(newPayload);
      printer("res : ${res.length}");
      if (newPayload.isLoadNext!) {
        secretList.addAll(res);
        if (res.length < limit) {
          hasMoreNext = false;
          printer("has more has been false");
        }
        firstSId = secretList.first.id;
        lastSId = secretList.last.id;
      } else {
        printer("loaded previous");
        secretList.insertAll(0, res);
        if (res.length < limit) {
          hasMorePrev = false;
          printer("has more has been false");
        }
        firstSId = secretList.first.id;
        lastSId = secretList.last.id;
      }
      update();
      printer("call 6");
      return res;
    } catch (e) {
      errorPrint(e);
    } finally {
      printer("call 7");
      isLoadingMore = false;
      update();
    }
    return null;
  }
}
