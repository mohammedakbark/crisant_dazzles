import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dio/dio.dart';

class UploadImageFromPORepo {
  static Future<Map<String, dynamic>> onUploadImage(
    List<int> productIds,
    String filepath,
  ) async {
    try {
      final userData = await LoginRefDataBase().getUserData;
      final formData = FormData(
        
      );
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            filepath,
            filename: basename(filepath),
            contentType: MediaType('image', 'jpg'),
          ),
        
        ),
      );
      for (var id in productIds) {
        formData.fields.add(MapEntry('productIds[]', id.toString()));
      }
      final response = await ApiConfig.postRequest(
        endpoint: ApiConstants.updateImageFromPo,
        header: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer ${userData.token}",
        },
        body: formData,
      );

      if (response.status == 200) {
        return {"error": false, "data": response.message};
      } else {
        return {"error": true, "data": response.message};
      }
    } catch (e) {
      return {"error": true, "data": e.toString()};
    }
  }
}
