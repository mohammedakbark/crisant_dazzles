import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/module/driver/check%20in/data/model/car_model_model.dart';

class GetModelRepo {
  static Future<Map<String, dynamic>> onGetModels(int brandId) async {
    final response = await ApiConfig.getRequest(
      endpoint: "${ApiConstants.getModel}/$brandId",
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
              (e) => CarModelModel.fromJson(e),
            )
            .toList()
      };
    } else if (response.message == "No models found for this make") {
      final List<CarModelModel> models = [];
      return {"error": false, "data": models};
    } else {
      return {"error": true, "data": response.message};
    }
  }
}
