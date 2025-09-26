import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';

class DeleteOperationRepo {
  static Future<Map<String, dynamic>> onDeleteOperation(
      String operationId) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.deleteRequest(
      endpoint: "${ApiConstants.deleteOperation}/$operationId",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      return {
        "data": response.message,
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
