import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/navigation/data/model/upcoming_product_model.dart';

class GetUpComingProductsListRepo {
  static Future<Map<String, dynamic>> onGetUpcomingProducts(
      int pageNumber) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.upcomingProductList}?page=$pageNumber",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final pagination = response.pagination;

      final data = response.data as List;
      final list = data
          .map(
            (e) => UpcomingProductsModel.fromJson(e),
          )
          .toList();
      log(list.length.toString());
      return {"error": false, "data": list, "pagination": pagination};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
