import 'dart:async';
import 'dart:developer';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/models/login_user_ref_model.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/Auth/data/models/user_role_mode.dart';
import 'package:dazzles/features/Auth/data/providers/resed_otp_controller.dart';
import 'package:dazzles/features/Auth/data/repo/get_app_permissions_repo.dart';
import 'package:dazzles/features/Auth/data/repo/login_repo.dart';
import 'package:dazzles/features/Auth/data/repo/login_with_mobilenumber_repo.dart';
import 'package:dazzles/features/Auth/data/repo/verify_OTP_repo.dart';
import 'package:dazzles/features/notification/data/providers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginController extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  FutureOr<Map<String, dynamic>?> build() {
    return null;
  }

  static int mainRoleId = 0;
  static String mainRole = "Office";
  Future<void> onLogin(
    String username,
    String password,
    UserRoleModel userRole,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await LoginRepo.onLogin(username, password);
    showMessageinUI(
        response['error'] == false ? "Login successful" : response['message'],
        response['error']);
    if (response['error'] == false) {
      final local = LocalUserRefModel(
          token: response['token'],
          userId: response['userId'],
          userName: response['username'],
          role: userRole.roleName,
          roleId: userRole.roleId);
      await LoginRefDataBase().setUseretails(local);
      // await FirebasePushNotification().initNotification(context);
      state = AsyncData(response);

      if (context.mounted) {
        naviagteToScreen(userRole, context);
      }
    } else {
      state = AsyncError("Error null", StackTrace.empty);
    }
  }

  Future<Map<String, dynamic>?> loginWithMobileNumber(
    UserRoleModel roleModel,
    String mobileNumber,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await LoginWithMobilenumberRepo.onLoginWithMobile(
        mobileNumber, roleModel.roleId);
    // ui response
    showMessageinUI(response['message'], response['error']);
    if (response['error'] == false) {
      state = AsyncData(response);
      return response['data'];
    } else {
      state = AsyncError("Error null", StackTrace.empty);
      return null;
    }
  }

  Future<void> resendOTP(
    UserRoleModel roleModel,
    String mobileNumber,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await LoginWithMobilenumberRepo.onLoginWithMobile(
        mobileNumber, roleModel.roleId);
    // ui response
    showMessageinUI(response['message'], response['error']);
    if (response['error'] == false) {
      state = AsyncData(response);
    } else {
      state = AsyncError("Error null", StackTrace.empty);
    }
  }

  Future<void> verifyOTP(
    int userId,
    String otp,
    UserRoleModel roleModel,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await VerifyOtpRepo.onVerifyOTP(otp, userId);
    // ui response
    showMessageinUI(response['message'], response['error']);
    if (response['error'] == false) {
      List<String> permissions = List.from(response['permissions']);
      final local = LocalUserRefModel(
          token: response['token'],
          userId: response['userId'],
          userName: response['username'],
          role: response['roleName'],
          permissions: permissions,
          roleId: roleModel.roleId);
      log("Permissions- \n${response['permissions']}");
      await LoginRefDataBase().setUseretails(local);
      await AppPermissionConfig().init(); // initializing app permission

      // ---- ---- ---- ---- ---- ---- ---- //
      await FirebasePushNotification().initNotification(context);

      state = AsyncData(response);
      if (context.mounted) {
        final ref = ProviderContainer();
        ref.read(resendOtpControllerProvider.notifier).dispose();

        naviagteToScreen(roleModel, context);

        // context.go(otherUsersRoute);
      }
    } else {
      state = AsyncError("Error null", StackTrace.empty);
    }
  }

  Future<void> getNewPermissions() async {
    final response = await GetAppPermissionsRepo.onGetAppPermissions();
    if (response['error'] == false) {
      List<String> permissions = List.from(response['data']);
      await LoginRefDataBase()
          .setUseretails(LocalUserRefModel(permissions: permissions));
      log(response['message']);
    } else {
      log("Error feting new permission" + response['message']);
    }
  }

  bool showMessage = false;
  bool? isError;
  String? message;

  void showMessageinUI(String message, bool isError) async {
    showMessage = true;
    this.isError = isError;
    this.message = message;
    await Future.delayed(Duration(seconds: 3));
    showMessage = false;
    this.isError = null;
    this.message = null;
    state = AsyncData({});
  }

//   void naviagteToScreen(
//       UserRoleModel currentUserRoleModel, BuildContext context) async {
//     switch (currentUserRoleModel.roleName) {
//       case "Office":
//         {
//           context.go(route);
//         }
//       case "Driver":
//         {
//           context.go(drNavScreen);
//         }
//       default:
//         {
//           context.go(otherUsersRoute);
//         }
//     }
//   }
// }
  void naviagteToScreen(
      UserRoleModel currentUserRoleModel, BuildContext context) async {
    context.go(routeScreen);
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, Map<String, dynamic>?>(
  LoginController.new,
);

final passwordObsecureControllerProvider = StateProvider(
  (ref) => true,
);

final mobileLoginControllerProvider = StateProvider(
  (ref) => false,
);
