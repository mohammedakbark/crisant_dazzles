import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class GetAppPermissionsRepo {
  static Future<Map<String, dynamic>> onGetAppPermissions() async {
    final userData = await LoginRefDataBase().getUserData;
    log(userData.token.toString());
    try {
      final response = await ApiConfig.getRequest(
        endpoint: ApiConstants.getAppPermissions,
        header: {
          "Authorization": "Bearer ${userData.token}",
          "Content-Type": "application/json"
        },
      );

      if (response.status == 200) {
        log(response.data.toString());
        return {
          "error": false,
          "data": response.data as List,
          "message": response.message
        };
      } else {
        return {"error": true, "message": response.message};
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }
}
