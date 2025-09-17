
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/recently%20uploded/data/model/recently_captured.dart';

class GetRecentlyCapturedRepo {
  static Future<Map<String, dynamic>> onGetRecentlyCaptured() async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.dashboardRecentlyCaptured,
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      // log(data.length.toString());
      return {
        "error": false,
        "data":
            data
                .map(
                  (e) =>
                      RecentCapturedModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
