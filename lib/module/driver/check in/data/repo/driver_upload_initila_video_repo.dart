import 'dart:io';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class DriverUploadInitilaVideoRepo {
  static Future<Map<String, dynamic>> onUploadIntilaVideo(
      double lat, double lon, File video, String valetId) async {
    final userData = await LoginRefDataBase().getUserData;

    String fileName = basename(video.path);
    FormData formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        video.path,
        filename: fileName,
        contentType: MediaType('video', 'mp4'),
      ),
      'latitude': lat,
      'longitude': lon
    });
    final response = await ApiConfig.postRequest(
        endpoint: "${ApiConstants.drUploadInitialVideo}/$valetId",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
        body: formData);

    if (response.status == 200) {
      final data = response.data as Map;
      return {"error": false, "data": data};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
