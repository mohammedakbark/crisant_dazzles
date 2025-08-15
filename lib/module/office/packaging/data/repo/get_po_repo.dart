import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/office/packaging/data/model/po_model.dart';

class GetPoRepo {
  static Future<Map<String, dynamic>> onGetAllPos
  (
    int pageNumber,
  ) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.allPurchases}?page=$pageNumber",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      return {
        "error": false,
        "data": data.map((e) => PoModel.fromJson(e)).toList(),
        "pagination": response.pagination,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
