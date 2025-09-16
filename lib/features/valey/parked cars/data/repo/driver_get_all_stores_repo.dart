import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/valey/parked%20cars/data/model/driver_store_model.dart';

class DriverGetAllStoresRepo {
  static Future<Map<String, dynamic>> onGetAllStores() async {
    try {
      final userData = await LoginRefDataBase().getUserData;
      final response = await ApiConfig.getRequest(
        endpoint: ApiConstants.getAllStoresList,
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );
      if (response.status == 200) {
        final data = response.data as List;

        // log(data.toString());
        return {
          "error": false,
          "data": data.map((e) => DriverStoreModel.fromJson(e)).toList(),
        };
      } else {
        return {"error": true, "data": response.message};
      }
    } catch (e) {
      return {"error": true, "data": e.toString()};
    }
  }
}
