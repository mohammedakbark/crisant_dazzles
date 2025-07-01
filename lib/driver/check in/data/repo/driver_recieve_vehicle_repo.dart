import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class DriverReceiveVehicleRepo {
  static Future<Map<String, dynamic>> onReceiveNewVehilce(
      String mobileNumber, String name, String qrId,String vehicleNumber) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.receiveVehicle,
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
        body: {
          "qrId": name,
          "vehicleNumber": vehicleNumber,
          "customerName": name,
          "customerNumber": mobileNumber,
          "storeId": 21
        });

    if (response.status == 200) {
      final data = response.data as Map;
      return {"error": false, "data": data};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
