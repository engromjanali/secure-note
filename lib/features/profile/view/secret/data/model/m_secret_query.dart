import 'package:cloud_firestore/cloud_firestore.dart';

class MSQuery {
  final int? pageNo;
  final int? limit;
  final bool? isLoadNext;
  final String? firstEid;
  final String? lastEid;
  // final String? where;
  List? args;

  MSQuery({
    // this.where,
    this.args,
    this.firstEid,
    this.lastEid,
    this.pageNo,
    this.limit,
    this.isLoadNext,
  });
}
