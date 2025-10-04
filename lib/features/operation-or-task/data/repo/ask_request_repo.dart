import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class AskRequestRepo {
  static Future<Map<String, dynamic>> requestForReEntry(
      int operationRecordId, String reason) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: "${ApiConstants.askRequest}",
      body: {"operationRecordId": operationRecordId, "reason": reason},
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
