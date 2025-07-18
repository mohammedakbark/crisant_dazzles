import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';

class SearchProductByIdRepo {
  static Future<Map<String, dynamic>> onSearchProductById(String query) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.searchProductById}$query",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as Map;
      log("Resposne"+data.toString());
      return {
        "error": false,
        "data": ProductModel.fromJson(data as Map<String, dynamic>),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
