
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/office/product/data/models/product_data_model.dart';

class GetProductDataRepo {
  static Future<Map<String, dynamic>> onGetProductData(int id) async {
    // log(id.toString());
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.productData+"/$id",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as Map;
      // log(data.toString());
      // log('//--------------------------------');
      return {
        "error": false,
        "data": ProductDataModel.fromJson(data as Map<String, dynamic>),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
