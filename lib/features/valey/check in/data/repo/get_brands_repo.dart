import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/features/valey/check%20in/data/model/car_brand_model.dart';

class GetBrandsRepo {
  static Future<Map<String, dynamic>> onGetBrands() async {
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.getBrand,
      header: {
        "Content-Type": "application/json",
      },
    );
    if (response.status == 200) {
      final data = response.data as List;
      return {
        "error": false,
        "data": data
            .map(
              (e) => CarBrandModel.fromJson(e),
            )
            .toList()
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
