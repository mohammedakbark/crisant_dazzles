import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
  
class SetNotificationRepo {
  static Future<void> setPushToken(String pushToken) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: ApiConstants.setTokenURL,
      body: {"pushToken": pushToken},
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );
// 
    log(response.message);
  }
}
