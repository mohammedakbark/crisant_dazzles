
// import 'package:dazzles/core/config/api_config.dart';
// import 'package:dazzles/core/constant/api_constant.dart';

// class LoginRepo {
//   static Future<Map<String, dynamic>> onLogin(
//     String userName,
//     String password,
//   ) async {
//     try {
//       final response = await ApiConfig.postRequest(
//         endpoint: ApiConstants.login,
//         header: {"Content-Type": "application/json"},
//         body: {"username": userName, "password": password},
//       );

//       if (response.status == 200) {
//         final data = response.data as Map;
//         return {
//           "error": false,
//           "token": data['token'],
//           "userId": data['user']['id'],
//           'username': data['user']['username'],
//           'role': data['user']['role'],
//         };
//       } else {
//         return {"error": true, "message": response.message};
//       }
//     } catch (e) {
//       return {"error": true, "message": e.toString()};
//     }
//   }
// }
