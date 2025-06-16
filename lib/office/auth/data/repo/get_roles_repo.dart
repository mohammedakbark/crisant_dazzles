import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/office/auth/data/models/user_role_mode.dart';

class GetRolesRepo {
  static Future<Map<String, dynamic>> onGetRoles() async {
    try {
      final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.userRoles,
        header: {"Content-Type": "application/json"},
      );

      if (response.status == 200) {
        final data = response.data as List;
        return {
          "error": false,
          "data": data
              .map(
                (e) => UserRoleModel.fromJson(e),
              )
              .toList(),
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
