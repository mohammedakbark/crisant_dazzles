import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/create_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';

class GetCreatedOperationsRepo {
  static Future<Map<String, dynamic>> onFetchCreatedOperations() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getCreatedOperations}",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 201) {
      final data = response.data as List;
      // log("Created operations length: ${data.length}");
      return {
        "data": data
            .map(
              (e) => CreatedOperationModel.fromJson(e),
            )
            .toList(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
