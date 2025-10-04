import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/create_operation_model.dart';

class VerifyAndUpdateTaskRequestRepo {
  static Future<Map<String, dynamic>> onUpdateRequest(
      CreateOperationModel newOperation) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: "${ApiConstants.verifyAndUpdateRequest}",
      body: newOperation.toJson(),
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 201) {
      log(response.message);
      return {
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
