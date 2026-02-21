import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/web/features_web/delete_data/data/model/delete_model.dart';
import 'package:secure_note/web/features_web/delete_data/data/repository/delete_repository_interface.dart';

// https://note-dd0cc-default-rtdb.firebaseio.com/messages/xyz.json
// the XYZ will be the today date,


// and as body you can pass any kind of json 
// ex:
// {
// "data" : user_unput_data,
// }

class DeleteRepository extends DeleteRepositoryInterface{
  final Dio _dio = Dio(
    BaseOptions(
                baseUrl : "https://note-dd0cc-default-rtdb.firebaseio.com",
                connectTimeout: const Duration(seconds: 60),
                receiveTimeout: const Duration(seconds: 60),
                contentType: "application/json",
              ),
            )..interceptors.addAll([
              LoggingInterceptor(),
              InterceptorsWrapper(
              onRequest: (options, handler) async {
                final token ='';
                //  await SharedPrefService.instance.getString(
                //   PKeys.usertoken,
                // );
                // options.headers['Content-Type'] = "application/json";
                options.headers['Authorization'] = "Bearer $token";
                printer("🔑 Bearer Token: $token");
                return handler.next(options);
              },
              onError: (error, handler) async {
                if (error.response?.statusCode == 401) {
                  // Token refresh logic if needed
                  // Handle error and retry if necessary
                }
                return handler.next(error);
              },
              onResponse: (response, handler) async {
                return handler.next(response);
              },
            ),
            ]);

  @override
  Future<void> sendDeleteRequest(DeleteModel payload)async{
    await _dio.post("/messages/${payload.id}.json", data: payload.toJson());
  }
}



// Custom logging interceptor
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printer("🚀 Requesting: ${options.method} ${options.uri}");
    printer("Headers: ${json.encode(options.headers)}");

    if (options.data is FormData) {
      final formData = options.data as FormData;
      printer("Payload (FormData): Fields - ${formData.fields}");
      if (formData.files.isNotEmpty) {
        printer(
          "Payload (FormData): Files - ${formData.files.map((file) => file.key).toList()}",
        );
      }
    } else {
      printer("Payload: ${json.encode(options.data)}");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printer(
      "✅ StatusCode [${response.statusCode}] from ${response.requestOptions.uri}",
    );
    printer("Response: ${json.encode(response.data)}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    errorPrint(
      "❌ Error [${err.response?.statusCode}] from ${err.requestOptions.uri}",
    );
    errorPrint("Error Message: ${json.encode(err.message)}");
    errorPrint("Error Data: ${json.encode(err.response?.data)}");
    super.onError(err, handler);
  }
}
