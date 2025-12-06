import 'package:secure_note/core/controllers/c_base.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/shared_preference_service.dart';
import 'package:secure_note/features/stopwatch/data/model/m_stopwatch.dart';
import 'package:secure_note/features/stopwatch/data/servics/stopwatch_service.dart';

class CStopwatch extends CBase {
  final StopWatchService _stopWatchService = StopWatchService.getInstance;
  MStopwatch mStopwatch = MStopwatch(
    isRunning: false,
    lapList: [],
    duration: Duration.zero,
  );

  void increment(MStopwatch payload) {
    _stopWatchService.saveCurrentStopwatchState(payload);
    mStopwatch = payload;
    update();
  }

  Future<void> initializeFromSharedPreferences() async {
    try {
      // Fetch the saved stopwatch state from SharedPreferences
      final MStopwatch? savedStopwatch = await StopWatchService.getInstance
          .getCurrentStopwatchState();

      if (savedStopwatch != null) {
        // Emit the saved state as initial state
        printer("stored pre stopwatch value");
        increment(savedStopwatch);
      } else {
        printer("state was not save in parsestance store");
      }
    } catch (e) {
      // Handle error, maybe log it
      // Continue with default state
      errorPrint('Error loading from SharedPreferences: $e');
    }
  }
}
