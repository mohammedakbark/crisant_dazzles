import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/features/navigation/data/model/image_pending_product_model.dart';

class GetImagePendingListRepo {
  static Future<Map<String, dynamic>> onGetImagePendingList(int page) async {
    final userData = await LoginRefDataBase().getUserData;
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.pendingImageList}?page=$page",
      header: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      final pagination=response.pagination;
      final list = data
          .map(
            (e) => ImagePendingProductsModel.fromJson(e),
          )
          .toList();
      return {"error": false, "data": list, "pagination": pagination};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
