import 'package:safe_device/safe_device.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:secure_note/core/functions/f_printer.dart';

// Future<bool> isDeviceTampered() async {
//   bool? jailbroken;
//   bool? developerMode;
//   // Platform messages may fail, so we use a try/catch PlatformException.
//   try {
//     jailbroken = await FlutterJailbreakDetection.jailbroken;
//     developerMode = await FlutterJailbreakDetection.developerMode;
//   } on PlatformException {
//     // platform failure = suspicious, but not always jailbroken
//     errorPrint("PlatformException in isDeviceTampered");
//     jailbroken = true;
//     developerMode = true;
//   } catch (e) {
//     errorPrint(e);
//   }
//   printer("jailbroken $jailbroken");
//   printer("developerMode $developerMode");
//   return ((jailbroken ?? false) || (developerMode ?? false));
// }

Future<bool> isDeviceCompromised() async {
  final isJailBroken = await SafeDevice.isJailBroken;
  final isRealDevice = await SafeDevice.isRealDevice;
  printer("jailbroken $isJailBroken");
  printer("isRealDevice $isRealDevice");
  return isJailBroken || !isRealDevice;
}
