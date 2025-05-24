
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class GetNotificationsRepo {
  static Future<Map<String, dynamic>> getAllNotifications() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.getNotificationsURL,
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      // final list=data.map((e) => Noti,)
      return {"error": false, "data": data};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
