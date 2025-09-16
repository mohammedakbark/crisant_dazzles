import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/valey/check%20in/data/model/driver_reg_customer_model.dart';

class DriverSuggestCustomerRepo {
  static Future<Map<String, dynamic>> onSuggestCustomer(
      String mobileNumber) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.drSuggestCustomer}?number=$mobileNumber",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      return {
        "error": false,
        "data": data
            .map(
              (e) => DriverCustomerSuggessionModel.fromJson(e),
            )
            .toList()
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
