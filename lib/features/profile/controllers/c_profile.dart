import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_loader.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/spalsh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_state/power_state.dart';
import '../../../../core/controllers/c_base.dart';
import '../data/models/m_profile.dart';
import '../data/repository/patient_repository.dart';

class CProfile extends CBase {
  final IProfileRepository _profileRepository;
  CProfile(IProfileRepository profileRepository)
    : _profileRepository = profileRepository {
    listenIUSTDFAD();
  }

  MProfile mProfileData = MProfile();
  String? hash;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool get isSigned => isNotNull(firebaseAuth.currentUser);
  StreamSubscription? authStatusListener;

  // functions
  Future getPatientList({bool isSignIn = false}) async {
    printer("getPatientList");
    if (isNull(firebaseAuth.currentUser?.uid)) {
      errorPrint("user are not signed!");
      return;
    }
    try {
      mProfileData = await _profileRepository.fetchProfile();
      if (isSignIn) {
        await FSSService().setString("sessionKey", mProfileData.sessionKey!);
      }
      printer(mProfileData.toJson());
    } catch (e, s) {
      setException(error: e, stackTrace: s);
    } finally {
      update();
    }
  }

  Future editPrifle(MProfile payload) async {
    try {
      showLoader();
      mProfileData = await _profileRepository.updateProfile(payload);
      Future.microtask(() => hideOverlay());
    } catch (e, s) {
      hideOverlay();
      setException(error: e, stackTrace: s);
    } finally {
      update();
    }
  }

  Future changeSessionKey() async {
    mProfileData.sessionKey = Random().nextInt(9999).toString();
    mProfileData.updatedAt = DateTime.timestamp();
    MProfile payload = mProfileData;
    try {
      showLoader();
      await FSSService().setString("sessionKey", payload.sessionKey!);
      await _profileRepository.changeSessionKey(payload);
      hideOverlay();
      showSnackBar("success!\nLogout From Another All Devices!");
    } catch (e, s) {
      hideOverlay();
      setException(error: e, stackTrace: s);
    } finally {
      update();
    }
  }

  // listen if user signout this device from anoter device,
  void listenIUSTDFAD() async {
    if (isNull(firebaseAuth.currentUser?.uid)) {
      printer(
        "retrying:  listenIUSTDFAD ${isNull(firebaseAuth.currentUser?.uid)}",
      );
      await Future.delayed(Duration(seconds: 5));
      listenIUSTDFAD();
      return;
    } else {
      printer("go ahed listenIUSTDFAD}");
    }
    authStatusListener?.cancel();
    authStatusListener = FirebaseFirestore.instance
        .collection(PKeys.users)
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen(
          (doc) async {
            try {
              final localVersion = await FSSService().getString("sessionKey");
              final serverVersion = doc.data()?["sessionKey"] ?? "";

              if (serverVersion != localVersion) {
                printer("local: $localVersion");
                printer("server: $serverVersion");
                await logOut();
              } else {
                printer("Done, Logout From Another All Devices!");
              }
            } catch (e) {
              errorPrint("Force SignOut error: $e");
            }
          },
          onError: (error) {
            errorPrint("Firestore stream error: $error");
          },
        );
  }

  Future<void> logOut() async {
    // SharedPrefService.instance.clear();
    firebaseAuth.signOut();
    mProfileData = MProfile();
    update();
    //Note: remove all of thing without local database key or related data.
    await FSSService().delete("sessionKey");
    await FSSService().delete("secondaryAuthKey");
    await FSSService().delete("attemptCount");
    PowerVault.delete<CProfile>();
    SpalshScreen().pushAndRemoveUntil();
  }
}
