import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';

class VerifyOtpRepo {
  static Future<Map<String, dynamic>> onVerifyOTP(String otp, int id) async {
    try {
      final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.verifyMobileOTP,
        header: {"Content-Type": "application/json"},
        body: {"otp": otp, "id": id},
      );

      if (response.status == 200) {
        final data = response.data as Map;
        return {
          "error": false,
          "token": data['token'],
          "userId": data['user']['id'],
          'username': data['user']['username'],
          'roleName': data['user']['role']['roleName'],
          "message": response.message,
          "permissions": data['user']['permissions']
        };
      } else {
        return {"error": true, "message": response.message};
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }
}
