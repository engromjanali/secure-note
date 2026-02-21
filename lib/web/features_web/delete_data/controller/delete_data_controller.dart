import 'dart:isolate';

import 'package:power_state/power_state.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/web/features_web/delete_data/data/model/delete_model.dart';
import 'package:secure_note/web/features_web/delete_data/data/model/status_model.dart';
import 'package:secure_note/web/features_web/delete_data/data/repository/delete_repository.dart';
import 'package:secure_note/web/features_web/delete_data/data/repository/delete_repository_interface.dart';

class DeleteDataController  extends PowerController{
  DeleteRepositoryInterface deleteRepositoryInterface = DeleteRepository();
  StatusModel? _statusModel;

  // get 
  StatusModel? get getStatusModel => _statusModel;

  // set 
  void setStatusModel(StatusModel? statusModel,{ bool notify= true}){
    _statusModel = statusModel;
    if(notify){
      notifyListeners();
    }
  }

  bool isLoading = false;

  void sendDeleteMessage(DeleteModel payload)async{
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));
      await deleteRepositoryInterface.sendDeleteRequest(payload);
      setStatusModel(
        StatusModel(
          id: payload.id,
          message: "Request sent successfully! We’ll contact you soon.",
          responseState: ResponseState.success,
        ),
        notify: false,
      );
    } catch (e) {
      errorPrint(e);
      setStatusModel(
        StatusModel(
          id: payload.id,
          message: "Somthing Want Wrong!",
          responseState: ResponseState.error,
        ),
        notify: false,
      );
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}