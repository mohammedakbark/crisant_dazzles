import 'dart:developer';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';

class GetAllListOfParkedCarsRepo {
  static Future<Map<String, dynamic>> onGetAllParkedCars(int pageNumber,
      {String? storeId}) async {
    try {
      String params;
      if (storeId != null) {
        params = '?page=$pageNumber&storeId=$storeId';
      } else {
        params = '?page=$pageNumber';
      }
      final userData = await LoginRefDataBase().getUserData;
      final response = await ApiConfig.postRequest(
        endpoint: "${ApiConstants.drGetAllParkedCarList}$params",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );
      if (response.status == 200) {
        final data = response.data as List;
        final pagination = response.pagination;

        // log(data.toString());
        return {
          "error": false,
          "data": data.map((e) => DriverParkedCarModel.fromJson(e)).toList(),
          "pagination": pagination,
        };
      } else {
        return {"error": true, "data": response.message};
      }
    } catch (e) {
      return {"error": true, "data": e.toString()};
    }
  }
}
