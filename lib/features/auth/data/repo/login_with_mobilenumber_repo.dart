import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';

class LoginWithMobilenumberRepo {
  static Future<Map<String, dynamic>> onLoginWithMobile(
    String mobileNumber,
    String role,
  ) async {
    try {
      final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.loginWithMobile,
        header: {"Content-Type": "application/json"},
        body: {"phone": mobileNumber, "mobileRole": role},
      );

      if (response.status == 200) {
        final data = response.data as Map;
        return {
          "error": false,
          "data": {"role": data['user']['role'], "id": data['user']['id']},
          "message": response.message
        };
      } else {
        return {"error": true, "message": response.message};
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }
}
