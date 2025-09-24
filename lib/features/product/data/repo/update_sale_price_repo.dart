import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class UpdateSalePriceRepo {
  static Future<Map<String, dynamic>> onUpdateSalePrice(
      String productId, String price) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.postRequest(
      endpoint: "${ApiConstants.updateProductPrice}/$productId",
      body: {"productSellingPrice": price},
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as Map;
      return {
        "data": data['productSellingPrice'].toString(),
        "error": false,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
