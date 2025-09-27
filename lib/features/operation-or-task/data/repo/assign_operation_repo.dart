import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class AssignOperationRepo {
  static Future<Map<String, dynamic>> assignOperation(
      String operationId, List<String> userIds) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: "${ApiConstants.assignOperation}",
      body: {
        "operationId": int.parse(operationId),
        "employeeIds": userIds
            .map(
              (e) => int.parse(e),
            )
            .toList()
      },
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 201 || response.status == 200) {
      log(response.message);
      return {
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
