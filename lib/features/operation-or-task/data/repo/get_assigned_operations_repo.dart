import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';

class GetToDoOperationTask {
  static Future<Map<String, dynamic>> onFetchToDoOperationTask() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getToDoOperations}",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      // log("To do operations length: ${data.length}");
      return {
        "data": data
            .map(
              (e) => ToDoOperationModel.fromJson(e),
            )
            .toList(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
