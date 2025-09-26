import 'dart:developer';

import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/models/response_model.dart';
import 'package:dazzles/core/shared/routes/route_provider.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
import 'package:dio/dio.dart';

class ApiConfig {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<ResponseModel> postRequest({
    required String endpoint,
    required Map<String, dynamic> header,
    Object? body,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: header),
      );
      // log(response.data.toString());

      return ResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        try {
          log("response 401  (No Error) POST");
          log(e.response!.data['message'].toString());
          _checkTokenExpired(e.response!.data);
          return ResponseModel.fromJson(e.response!.data);
        } catch (_) {
          log("response 401  (Error) POST");

          return ResponseModel(
            data: null,
            error: true,
            message: "Server error !",
            status: e.response?.statusCode ?? 500,
          );
        }
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        log("Connection Error ! POST");
        return ResponseModel(
          data: null,
          error: true,
          message: "No Internet Connection!",
          status: 503,
        );
      }
      log("Dio Error POST");
      return ResponseModel(
        data: null,
        error: true,
        message: "Dio Error: ${e.message}",
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log("Unexpected Error POST");
      return ResponseModel(
        data: null,
        error: true,
        message: "Unexpected Error: $e",
        status: 500,
      );
    }
  }

  //---------------------------GET

  static Future<ResponseModel> getRequest({
    required String endpoint,
    required Map<String, dynamic> header,
    Object? body,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        data: body,
        options: Options(headers: header),
      );

      // Directly use response.data instead of decoding again
      // log(response.data.toString());

      return ResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        try {
          // log(e.response!.data);
          log("response 401  (No Error)");
          log(e.response!.data['message'].toString());
          _checkTokenExpired(e.response!.data);
          return ResponseModel.fromJson(e.response!.data);
        } catch (_) {
          log("response 401  (Error)");

          return ResponseModel(
            data: null,
            error: true,
            message: "Server error !",
            status: e.response?.statusCode ?? 500,
          );
        }
      }
      // 🔌 Handle no internet connection
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        log("Connection Error !");

        return ResponseModel(
          data: null,
          error: true,
          message: "No Internet Connection!",
          status: 503,
        );
      }

      // 🧾 If server returned a valid response (like 401), parse that
      log("Dio Error");

      return ResponseModel(
        data: null,
        error: true,
        message: "Dio Error: ${e.message}",
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log("Unexpected Error");

      return ResponseModel(
        data: null,
        error: true,
        message: "Unexpected Error: $e",
        status: 500,
      );
    }
  }

  //---------------------------PATCH
  static Future<ResponseModel> patchRequest({
    required String endpoint,
    required Map<String, dynamic> header,
    Object? body,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: body,
        options: Options(headers: header),
      );

      // log(response.data.toString());
      return ResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        try {
          log("response 401  (No Error) PATCH");
          log(e.response!.data['message'].toString());
          _checkTokenExpired(e.response!.data);
          return ResponseModel.fromJson(e.response!.data);
        } catch (_) {
          log("response 401  (Error) PATCH");

          return ResponseModel(
            data: null,
            error: true,
            message: "Server error !",
            status: e.response?.statusCode ?? 500,
          );
        }
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        log("Connection Error ! PATCH");
        return ResponseModel(
          data: null,
          error: true,
          message: "No Internet Connection!",
          status: 503,
        );
      }
      log("Dio Error PATCH");
      return ResponseModel(
        data: null,
        error: true,
        message: "Dio Error: ${e.message}",
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log("Unexpected Error PATCH");
      return ResponseModel(
        data: null,
        error: true,
        message: "Unexpected Error: $e",
        status: 500,
      );
    }
  }

  //---------------------------DELETE
  static Future<ResponseModel> deleteRequest({
    required String endpoint,
    required Map<String, dynamic> header,
    Object? body, // optional body (Dio supports data for DELETE)
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        options: Options(headers: header),
      );

      // log(response.data.toString());
      return ResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        try {
          log("response 401  (No Error) DELETE");
          log(e.response!.data['message'].toString());
          _checkTokenExpired(e.response!.data);
          return ResponseModel.fromJson(e.response!.data);
        } catch (_) {
          log("response 401  (Error) DELETE");

          return ResponseModel(
            data: null,
            error: true,
            message: "Server error !",
            status: e.response?.statusCode ?? 500,
          );
        }
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        log("Connection Error ! DELETE");
        return ResponseModel(
          data: null,
          error: true,
          message: "No Internet Connection!",
          status: 503,
        );
      }
      log("Dio Error DELETE");
      return ResponseModel(
        data: null,
        error: true,
        message: "Dio Error: ${e.message}",
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log("Unexpected Error DELETE");
      return ResponseModel(
        data: null,
        error: true,
        message: "Unexpected Error: $e",
        status: 500,
      );
    }
  }

  static void _checkTokenExpired(data) async {
    if (data['error'] == true && data['message'] == "jwt expired") {
      await NavProfileScreen.logout(rootNavigatorKey.currentContext!);
    }
  }
}
