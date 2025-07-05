import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/office/home/data/models/dashboard_model.dart';

class DriverQrCodeScanRepo {
  static Future<Map<String, dynamic>> onScanQrCode(String qrCode) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.drScanQrCode,
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
        body: {
          "qrCode": qrCode
        });

    if (response.status == 200) {
      final data = response.data as Map;
      return {
        "error": false,
        "data": data['qrId'].toString(),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
