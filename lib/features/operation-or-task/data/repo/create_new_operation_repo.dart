import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/create_operation_model.dart';

class CreateNewOperationRepo {
  static Future<Map<String, dynamic>> onCreateNewOperation(
      CreateOperationModel newOperation) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: "${ApiConstants.createNewOperation}",
      body: newOperation.toJson(),
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 201) {
      // final data = response.data as Map;
      log(response.message);
      return {
        // "data": data['productSellingPrice'].toString(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
