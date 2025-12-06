import 'package:secure_note/core/constants/all_enums.dart';

class MQuery {
  final int? pageNo;
  final int? limit;
  final bool? isLoadNext;
  // final int? firstEid;
  // final int? lastEid;
  final String? where;
  List? args;
  final TaskState? taskState;
  MQuery({
    this.where,
    this.args,
    this.taskState,
    // this.firstEid,
    // this.lastEid,
    this.pageNo,
    this.limit,

    this.isLoadNext,
  });
}
