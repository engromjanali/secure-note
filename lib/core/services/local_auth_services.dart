import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthServices {
  LocalAuthServices._();
  static LocalAuthServices instance = LocalAuthServices._();
  factory LocalAuthServices() => instance;
  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> showBiometric({bool biometricOnly = false}) async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        // biomatric found
        if (availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.face)) {
          // Specific types of biometrics are available.
          // Use checks like this with caution!
          // may it's ignore face in android.
        }
        printer(availableBiometrics);
        return authenticate(biometricOnly: biometricOnly);
      } else {
        // biomatric not found
        return authenticate(biometricOnly: biometricOnly);
      }
    } else {
      // can't authenticate
      printer("No Authentication Option Found!");
      return false;
    }
  }

  Future<bool> authenticate({bool biometricOnly = false}) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        biometricOnly: biometricOnly,
        localizedReason: 'Please Authenticate Your Self',
      );
      return didAuthenticate;
    } on LocalAuthException catch (e) {
      handelLocalAuthException(e);
    } catch (_) {
      showSnackBar("Unexcepted Error!");
    }
    // Exception Caught
    return false;
  }

  void handelLocalAuthException(LocalAuthException error) {
    switch (error.code) {
      case LocalAuthExceptionCode.userCanceled:
        // it's normal
        return;
      case LocalAuthExceptionCode.temporaryLockout:
        showSnackBar("Temporary Locked");
        return;
      case LocalAuthExceptionCode.timeout:
        showSnackBar("Timeout");
        return;
      case LocalAuthExceptionCode.noBiometricsEnrolled:
        showSnackBar("No Biometrics Enrolled");
        return;
      case LocalAuthExceptionCode.uiUnavailable:
        showSnackBar("Ui Unavailable");
        return;
      case LocalAuthExceptionCode.deviceError:
        showSnackBar("Device Error");
        return;
      case LocalAuthExceptionCode.biometricLockout:
        showSnackBar("Biometric Lockout");
        return;
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable ||
          LocalAuthExceptionCode.noBiometricHardware:
        showSnackBar("Biometric Hardware Temporarily Unavailable");
        return;
      case LocalAuthExceptionCode.authInProgress:
        showSnackBar(
          "An authentication operation is already in progress, and has not completed.",
        );
        return;
      default:
        showSnackBar("Somthing Want Wrong!");
        return;
    }
  }
}
