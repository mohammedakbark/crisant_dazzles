import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/office/home/data/models/dashboard_model.dart';

class DriverSuggestCustomerRepo {
  static Future<Map<String, dynamic>> onSuggestCustomer(
      String mobileNumber) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.drSearchCustomer}?number=$mobileNumber",
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
              (e) => DriverRegCustomerModel.fromJson(e),
            )
            .toList()
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
