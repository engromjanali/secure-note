import 'dart:async';

class TimerService {
  Timer? _timer;
  static TimerService _instance = TimerService._();
  TimerService._();
  factory TimerService() => _instance;
  listen(Function() callback, {Duration? duration}) {
    _timer?.cancel();
    _timer = Timer.periodic(duration ?? Duration(seconds: 1), (_) {
      callback.call();
    });
  }

  stop() {
    _timer?.cancel();
  }
}
