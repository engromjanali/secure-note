class MStopwatch {
  bool isRunning;
  Duration duration;
  List<Duration> lapList;
  DateTime? startTime;

  // main constractor
  MStopwatch({
    required this.isRunning,
    required this.duration,
    required this.lapList,
    this.startTime,
  });

  // json/map
  Map toJson() {
    return {
      "isRunning": isRunning,
      "lapList": lapList.map((e) => e.inMilliseconds).toList(),
      "startTime": startTime?.toIso8601String(),
      "duration": duration.inMilliseconds,
    };
  }

  // copy with
  /// why it's importent if we pass a reference and if we modified the data inside function it's will change primary data also.
  /// that's why we can send/pass the same data with a new/different reference using "copyWith". so my primary data are safe.
  MStopwatch copyWith({
    bool? isRunning,
    Duration? duration,
    List<Duration>? lapList,
    DateTime? startTime,
  }) {
    return MStopwatch(
      isRunning: isRunning ?? this.isRunning,
      duration: duration ?? this.duration,
      lapList: lapList ?? this.lapList,
      startTime: startTime ?? this.startTime,
    );
  }

  factory MStopwatch.fromJson(Map<String, dynamic> json) {
    return MStopwatch(
      isRunning: json["isRunning"],
      duration: Duration(milliseconds: json["duration"]),
      lapList: (json["lapList"] as List<dynamic>)
          .map((e) => Duration(milliseconds: e))
          .toList(),
      startTime: json["startTime"] != null
          ? DateTime.parse(json["startTime"] as String)
          : null,
    );
  }
}
