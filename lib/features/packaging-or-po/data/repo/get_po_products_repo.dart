import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/packaging-or-po/data/model/po_product_model.dart';

class GetPoProductsRepo {
  static Future<Map<String, dynamic>> onGetPoProducts(
      int page, int id, String? query) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint:
          "${ApiConstants.getPurshaseOrderProducts}/$id?page=$page&search=${query ?? ''}",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      return {
        "error": false,
        "data": data.map((e) => PoProductModel.fromJson(e)).toList(),
        "pagination": response.pagination,
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
