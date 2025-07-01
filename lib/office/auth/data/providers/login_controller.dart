import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/models/login_user_ref_model.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/office/auth/data/models/user_role_mode.dart';
import 'package:dazzles/office/auth/data/providers/resed_otp_controller.dart';
import 'package:dazzles/office/auth/data/repo/get_roles_repo.dart';
import 'package:dazzles/office/auth/data/repo/login_repo.dart';
import 'package:dazzles/office/auth/data/repo/login_with_mobilenumber_repo.dart';
import 'package:dazzles/office/auth/data/repo/verify_OTP_repo.dart';
import 'package:dazzles/office/notification/data/providers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// final loginProvider =
//     FutureProvider.family<Map<String, dynamic>?, Map<String, dynamic>>((
//       ref,
//       arg,
//     ) async {
//       final authService = LoginRepo();
//       return authService.onLogin(arg['username'], arg['password']);
//     });

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
        context.go(route);
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
      final local = LocalUserRefModel(
          token: response['token'],
          userId: response['userId'],
          userName: response['username'],
          role: response['roleName'],
          roleId: roleModel.roleId);
      await LoginRefDataBase().setUseretails(local);
      await FirebasePushNotification().initNotification(context);
      state = AsyncData(response);
      if (context.mounted) {
        final ref = ProviderContainer();
        ref.read(resendOtpControllerProvider.notifier).dispose();
        
        context.go(drNavScreen);

        // context.go(otherUsersRoute);
      }
    } else {
      state = AsyncError("Error null", StackTrace.empty);
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
