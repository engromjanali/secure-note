class StatusModel{
  String? id;
  String? message;
  ResponseState? responseState;

  StatusModel({
    this.id,
    this.message,
    this.responseState,
  });
}

enum ResponseState {error, success}