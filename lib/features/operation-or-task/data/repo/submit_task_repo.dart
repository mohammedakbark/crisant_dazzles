import 'dart:developer';
import 'dart:io';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class SubmitTaskRepo {
  static Future<Map<String, dynamic>> onSubmitTask(
      String operationId, String assignedId,
      {String? text, File? video, File? image}) async {
    final userData = await LoginRefDataBase().getUserData;
    ResponseModel? response;
    final formData = FormData();

    if (video != null) {
      formData.files.add(
        MapEntry(
          'video',
          await MultipartFile.fromFile(
            video.path,
            filename: basename(video.path),
            contentType: MediaType('video', 'mp4'),
          ),
        ),
      );
      formData.fields.add(MapEntry('operationId', operationId));
      formData.fields.add(MapEntry('assignedId', assignedId));

      response = await ApiConfig.postRequest(
        body: formData,
        endpoint: "${ApiConstants.submitTask}/video",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );
    } else if (image != null) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: basename(image.path),
            contentType: MediaType('image', 'jpg'),
          ),
        ),
      );
      formData.fields.add(MapEntry('operationId', operationId));
      formData.fields.add(MapEntry('assignedId', assignedId));
      response = await ApiConfig.postRequest(
        body: formData,
        endpoint: "${ApiConstants.submitTask}/image",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );
    } else {
      response = await ApiConfig.postRequest(
        body: {
          "operationId": operationId,
          "assignedId": assignedId,
          "text": text
        },
        endpoint: "${ApiConstants.submitTask}/text",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );
    }

    if (response.status == 201 || response.status == 200) {
      return {
        "error": false,
        "data": response.message,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
