import 'dart:convert';
import 'package:daily_info/core/constants/env.dart';
import 'package:daily_info/core/constants/keys.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/shared_preference_service.dart';
import 'package:dio/dio.dart';

// Enum for HTTP methods
enum HTTPMethod { get, post, delete, patch, put, multiPart }

// Singleton DioService class for configuring Dio instance
class DioService {
  DioService._internal();

  static DioService? _instance;

  static DioService get instance {
    _instance ??= DioService._internal();
    return _instance!;
  }

  Dio? _dio;

  Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: ENV().baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        contentType: "application/json",
      ),
    )..interceptors.addAll([
        LoggingInterceptor(), // Add custom logging interceptor
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await SharedPrefService.instance.getString(PKeys.usertoken);
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
        )
      ]);

    return _dio!;
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
        printer("Payload (FormData): Files - ${formData.files.map((file) => file.key).toList()}");
      }
    } else {
      printer("Payload: ${json.encode(options.data)}");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printer("✅ StatusCode [${response.statusCode}] from ${response.requestOptions.uri}");
    printer("Response: ${json.encode(response.data)}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    errorPrint("❌ Error [${err.response?.statusCode}] from ${err.requestOptions.uri}");
    errorPrint("Error Message: ${json.encode(err.message)}");
    errorPrint("Error Data: ${json.encode(err.response?.data)}");
    super.onError(err, handler);
  }
}

Future<Response> makeRequest({
  required String path,
  required HTTPMethod method,
  dynamic data, // Allow direct passing of data
  Map<String, dynamic>? formDataFields, // Optional
  List<MultipartFile>? files, // Optional
}) async {
  if (method == HTTPMethod.multiPart) {
    if (data == null) {
      // Construct FormData only if `data` is not directly passed
      if (formDataFields == null && files == null) {
        throw ArgumentError('formDataFields or files must be provided for multipart requests.');
      }

      data = FormData.fromMap({
        ...?formDataFields,
        if (files != null) 'files': files,
      });
    }
  }

  // Handle different HTTP methods
  switch (method) {
    case HTTPMethod.get:
      return DioService.instance.dio.get(path);
    case HTTPMethod.post:
      return DioService.instance.dio.post(path, data: data);
    case HTTPMethod.put:
      return DioService.instance.dio.put(path, data: data);
    case HTTPMethod.delete:
      return DioService.instance.dio.delete(path, data: data);
    case HTTPMethod.patch:
      return DioService.instance.dio.patch(path, data: data);
    case HTTPMethod.multiPart:
      return DioService.instance.dio.post(
        path,
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
  }
}
