import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class DriverReceiveVehicleRepo {
  static Future<Map<String, dynamic>> onReceiveNewVehilce(
      String mobileNumber,
      String name,
      String qrId,
      String regNumber,
      String brand,
      String model,
      int? carId,
      int? customerId) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.receiveVehicle,
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
        body: {
          "qrId": qrId,
          "customerName": name,
          "mobileNumber": mobileNumber,
          "model": model,
          "brand": brand,
          "vehicleNumber": regNumber,
          "carId": carId,
          "customerId": customerId,
        });

    if (response.status == 200) {
      final data = response.data as Map;
      return {"error": false, "data": data};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
