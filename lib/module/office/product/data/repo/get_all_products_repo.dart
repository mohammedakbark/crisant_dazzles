import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';

class GetAllProductsRepo {
  static Future<Map<String, dynamic>> onGetAllProducts(int pageNumber) async {
    try {
      final userData = await LoginRefDataBase().getUserData;
      final response = await ApiConfig.getRequest(
        endpoint: "${ApiConstants.allProduct}?page=$pageNumber",
        header: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userData.token}",
        },
      );

      if (response.status == 200) {
        final data = response.data as List;
        final pagination = response.pagination;

        // log(pagination["total"].toString());
        return {
          "error": false,
          "data": data.map((e) => ProductModel.fromJson(e)).toList(),
          "pagination": pagination,
        };
      } else {
        return {"error": true, "data": response.message};
      }
    } catch (e) {
      // log(e.toString());
      return {"error": true, "data": e.toString()};
    }
  }
}
