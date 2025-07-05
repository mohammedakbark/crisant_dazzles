import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_customer_car_suggession_model.dart';

class DriverGetCustomerVehiclesRepo {
  static Future<Map<String, dynamic>> getCustomerVehicleRepo(
      int customerId) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.drSuggestCustomerVehicles}?customerId=$customerId",
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
              (e) => DriverCustomerCarSuggessionModel.fromJson(e),
            )
            .toList()
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
