import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local%20data/login_red_database.dart';
import 'package:dio/dio.dart';

class UploadImageRepo {
  static Future<Map<String, dynamic>> onUploadImage(
    dynamic productId,
    File file,
  ) async {
    try {
      final userData = await LoginRefDataBase().getUserData;

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path),

          contentType: MediaType('image', 'png'), // ✅ Correct content type
        ),
      });
      final response = await ApiConfig.postRequest(
        endpoint: "${ApiConstants.updateImage}/$productId",
        header: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer ${userData.token}",
        },
        body: formData,
      );

      if (response.status == 200) {
        return {"error": false, "data": response.message};
      } else {
        return {"error": true, "data": response.message};
      }
    } catch (e) {
      return {"error": true, "data": e.toString()};
    }
  }
}
