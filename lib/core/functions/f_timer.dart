import 'dart:async';

import 'package:secure_note/core/functions/f_printer.dart';

class TimerService {
  Timer? _timer;
  static TimerService _instance = TimerService._();
  TimerService._();
  factory TimerService() => _instance;
  listen(Function() callback, {Duration? duration}) {
    printer("timer service running");
    _timer?.cancel();
    _timer = Timer.periodic(duration ?? Duration(seconds: 1), (_) {
      callback.call();
    });
  }

  stop() {
    printer("timer service stoped");
    _timer?.cancel();
  }
}
