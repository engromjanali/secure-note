import 'package:daily_info/core/constants/all_enums.dart';

class MQuery {
  final int? pageNo;
  final int? limit;
  final bool? isLoadNext;
  // final int? firstEid;
  // final int? lastEid;
  final String? filter;
  final TaskState? taskState;
  MQuery({
    this.filter,
    this.taskState,
    // this.firstEid,
    // this.lastEid,
    this.pageNo,
    this.limit,

    this.isLoadNext,
  });
}
