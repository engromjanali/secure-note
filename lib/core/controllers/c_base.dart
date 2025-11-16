import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:daily_info/core/widgets/load_and_error/models/view_state_model.dart';
import 'package:dio/dio.dart';
import 'package:power_state/power_state.dart';

/// 🧩 CBase — A reusable base power_state controller
/// - ✅ Tracks loading/error state for views
/// - ⚠️ Manages exception messages
/// - 📣 Optional snackbars for UI feedback
/// 📌 Extend this class to inherit state + error handling in all controllers.
class CBase extends PowerController {
  ViewState viewState = ViewState.initial;
  Object? _exception;
  Object? get exception {
    return _exception;
  }

  void setException({
    required Object? error,
    required StackTrace? stackTrace,
    bool showSnackbar = true,
    bool setExceptionOnly = false,
  }) {
    errorPrint("Error =====>: $error");
    _exception = error;
    if (setExceptionOnly == false) {
      viewState = ViewState.error;
      update();
    }

    if (showSnackbar == true) {
      showSnackBar(errorMsg(), snackBarType: SnackBarType.warning);
    }
    // TODO: Add Sentry here so that we can observe the error analytics //
  }

  void update() {
    notifyListeners();
  }

  String errorMsg() {
    if (exception is DioException) {
      final dioError = exception as DioException;

      if (dioError.type == DioExceptionType.cancel) {
        return "Request to API server was cancelled";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        return "Connection timeout with API server";
      } else if (dioError.type == DioExceptionType.connectionError ||
          dioError.type == DioExceptionType.unknown) {
        return "There is no internet connection";
      } else if (dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        return "Timeout in connection with API server";
      } else if (dioError.type == DioExceptionType.badCertificate) {
        return "Something went wrong! Try again";
      } else {
        return dioError.response?.data['message'] ??
            dioError.response?.data['CustomerErrorMessage'] ??
            dioError.response?.data['Message'] ??
            "Something went wrong! Try again";
      }
    } else {
      return exception.toString();
    }
  }
}
