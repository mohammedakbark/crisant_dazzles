import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/office/profile/data/models/user_profile_model.dart';

class GetProfileRepo {
  static Future<Map<String, dynamic>> onGetProfileData() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.profile,
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as Map;
      return {
        "error": false,
        "data": UserProfileModel.fromJson(data as Map<String, dynamic>),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
