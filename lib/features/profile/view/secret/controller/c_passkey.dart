import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/controllers/c_base.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/passkey/passkey_repository.dart';

class CPasskey extends CBase {
  final IPasskeyRepository _iPasskeyRepository;
  CPasskey(this._iPasskeyRepository);

  List<MPasskey> passkeyList = [];
  final int limit = PDefaultValues.limit;
  String? firstSId;
  String? lastSId;
  bool hasMoreNext = true;
  bool hasMorePrev = false;
  bool isLoadingMore = false;
  bool isLoadNext = true;

  void clear() {
    passkeyList = [];
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

  Future<void> addPasskey(MPasskey payload) async {
    printer("addPasskey ${payload.toString()}");
    // try {
    isLoadingMore = true;
    update();
    await _iPasskeyRepository.addPasskey(payload);
    // await Future.delayed(Duration(seconds: 2));
    showSnackBar("Passkey Added Successfully.");
    printer(passkeyList.length);
    // } catch (e) {
    // errorPrint(e);
    // } finally {
    isLoadingMore = false;
    update();
    // }
  }

  Future<void> updatePasskey(MPasskey payload) async {
    try {
      isLoadingMore = true;
      update();
      await _iPasskeyRepository.updatePasskey(payload);
      showSnackBar("Passkey Updated Successfully.");
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> deletePasskey(String id) async {
    try {
      isLoadingMore = true;
      update();
      printer("delete $id");
      await _iPasskeyRepository.detetePasskey(id);
      // clear from runtime storage
      passkeyList.removeWhere((mPasskey) => mPasskey.id == id);
      showSnackBar("Passkey Deleted!");
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> fetchPasskey({MSQuery? payload}) async {
    passkeyList.clear();
    await fetchSpacificItem(payload: payload);
  }

  Future<List<MPasskey>?> fetchSpacificItem({MSQuery? payload}) async {
    try {
      MSQuery newPayload = MSQuery(
        isLoadNext: payload?.isLoadNext ?? true,
        limit: payload?.limit ?? limit,
        firstEid: payload?.firstEid ?? firstSId,
        lastEid: payload?.lastEid ?? lastSId,
      );
      // set load from flag
      isLoadNext = payload?.isLoadNext ?? true;
      printer(isLoadNext);

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
      List<MPasskey> res = await _iPasskeyRepository.fetchPasskey(newPayload);
      printer(res.length);
      await Future.delayed(Duration(seconds: 5));
      if (newPayload.isLoadNext!) {
        passkeyList.addAll(res);
        if (res.length < limit) {
          hasMoreNext = false;
          printer("has more next has been false");
        }
        firstSId = passkeyList.first.id;
        lastSId = passkeyList.last.id;
      } else {
        printer("loaded previous");
        passkeyList.insertAll(0, res);
        if (res.length < limit) {
          hasMorePrev = false;
          printer("has more hasMorePrev has been false");
        }
        firstSId = passkeyList.first.id;
        lastSId = passkeyList.last.id;
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
