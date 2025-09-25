import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/scan%20product/data/model/scanned_product_model.dart';
import 'package:dazzles/features/packaging-or-po/data/model/supplier_model.dart';

class GetProductDetailsRepo {
  static Future<Map<String, dynamic>> onGetDetials(String productId) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getScannedProductDetails}/$productId",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      // log(response.data.toString());
      final data = response.data as Map;
      return {
        "error": false,
        "data": ScannedProductModel.fromJson(data as Map<String, dynamic>),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
