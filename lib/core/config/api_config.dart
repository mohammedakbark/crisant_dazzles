import 'dart:convert';
import 'dart:developer';

import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/models/response_model.dart';
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
    Map<String, dynamic>? body,
  }) async {
    try {
      Response response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: header),
      );
      final decodedata = jsonDecode(response.toString());
      // log(decodedata.toString());
      if (decodedata['error'] == false && decodedata['data'].isEmpty) {
        return ResponseModel(
          data: null,
          error: true,
          message: "Data Not Found!",
          status: 500,
        );
      } else {
        return ResponseModel.fromJson(decodedata);
      }
    } on DioException catch (e) {
      log("❌ Internet Connection Error : ${e.message}");
      if (e.type == DioExceptionType.connectionError) {
        return ResponseModel(
          data: null,
          error: true,
          message: "No Internet Connection!",
          status: 500,
        );
      } else {
        log("❌ Other Dio Error: ${e.message}");
        return ResponseModel(
          data: null,
          error: true,
          message: "Other Dio Error: ${e.message}",
          status: 500,
        );
      }
    } catch (e) {
      log("API Error: $e");
      return ResponseModel(
        data: null,
        error: true,
        message: "API Error: $e",
        status: 500,
      );
    }
  }
}
