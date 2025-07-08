import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class DriverDashboardRepo {
  static Future<Map<String, dynamic>> onFetchDriverDashboardData() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.drDashboardData,
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as Map;
      return {
        "error": false,
        "data": data,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
