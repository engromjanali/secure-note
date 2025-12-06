import 'package:secure_note/core/controllers/c_theme.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/data/data_source/profile_data_source_impl.dart';
import 'package:secure_note/features/profile/data/repository/patient_repository_impl.dart';
import 'package:secure_note/features/s_home.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';
import '/./core/services/navigation_service.dart';
import '../constants/keys.dart';
import '../functions/f_is_null.dart';
import '../services/shared_preference_service.dart';

/// 🔁 A checkpoint to handle initialization and navigation after a short delay.
class CCheckPoint {
  Future<void> initialization() async {
    callBackFunction(() async {
      printer("a");
      await Future.delayed(const Duration(milliseconds: 500));
      final context = NavigationService.currentContext;
      if (!context.mounted) return;
      final Brightness brightness = MediaQuery.of(context).platformBrightness;
      final bool isDarkMode = brightness == Brightness.dark;
      int? themeIndex = await SharedPrefService.instance.getInt(
        PKeys.themeIndex,
      );
      final CTheme cTheme = PowerVault.find<CTheme>();
      cTheme.updateTheme(index: themeIndex ?? (isDarkMode ? 1 : 0));
      final CProfile cProfile = PowerVault.put(
        CProfile(ProfileRepositoryImpl(ProfileDataSourceImpl())),
      );
      String? token = await SharedPrefService.instance.getString(
        PKeys.usertoken,
      );
      // in here we are going ahed even user dose not signed.
      if (!isNull(token) || true) {
        await cProfile.getPatientList();
      }
      printer("b");
      await const SHome().pushAndRemoveUntil();
    });
  }
}
