import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/operation_dashboard_model.dart';

class GetOperationDashboardRepo {
  static Future<Map<String, dynamic>> onFetchOperationDashboard() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getOperationDashboard}",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200 || response.status == 201) {
      final data = response.data as Map;
      return {
        "data": OperationDashboardModel.fromJson(data as Map<String, dynamic>),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
