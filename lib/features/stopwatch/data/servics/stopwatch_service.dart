import 'dart:convert';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/shared_preference_service.dart';
import 'package:secure_note/features/stopwatch/data/model/m_stopwatch.dart';

class StopWatchService {
  static StopWatchService getInstance = StopWatchService._();
  final SharedPrefService sharedPrefService = SharedPrefService.instance;
  StopWatchService._();

  Future<void> saveCurrentStopwatchState(MStopwatch? mStopwatch) async {
    try {
      if (mStopwatch == null) return;
      await sharedPrefService.setString(
        "currentStopWatchState",
        jsonEncode(mStopwatch.toJson()),
      );
    } catch (e) {
      errorPrint(e);
    }
  }

  Future<MStopwatch?> getCurrentStopwatchState() async {
    try {
      var rawData = await sharedPrefService.getString("currentStopWatchState");
      if (isNull(rawData)) {
        return null;
      }
      Map<String, dynamic> data = await jsonDecode(rawData);
      return MStopwatch.fromJson(data);
    } catch (e) {
      errorPrint(e);
      return null;
    }
  }
}
