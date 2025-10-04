
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/operation-or-task/data/model/operation_request_model.dart';

class GetOperationRequestRepo {
  static Future<Map<String, dynamic>> onFetchReuqests() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getRequestList}",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200 || response.status == 201) {
      final data = response.data as List;
      return {
        "data": data
            .map(
              (e) => OperationRequestModel.fromJson(e),
            )
            .toList(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
