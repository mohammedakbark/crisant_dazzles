import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_employee_status_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';

class GetAssignedEmployeeStatus {
  static Future<Map<String, dynamic>> onFetctOperationAssignedEmployees(
      String operationId) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getOperationAssignedEmployees}/$operationId",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      return {
        "data": data
            .map(
              (e) => AssignedEmployeeStatusModel.fromJson(e),
            )
            .toList(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
