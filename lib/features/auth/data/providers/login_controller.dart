import 'dart:async';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/models/login_user_ref_model.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/auth/data/repo/login_repo.dart';
import 'package:dazzles/features/auth/data/repo/login_with_mobilenumber_repo.dart';
import 'package:dazzles/features/notification/data/providers/notification_controller.dart';
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

  static String mainRole = "Office";
  Future<void> onLogin(
    String username,
    String password,
    String selectedRole,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await LoginRepo.onLogin(username, password);
    if (response['error'] == false) {
      final local = LocalUserRefModel(
          token: response['token'],
          userId: response['userId'],
          userName: response['username'],
          role: selectedRole);
      await LoginRefDataBase().setUseretails(local);
      state = AsyncData(response);
      await FirebasePushNotification().initNotification(context);

      if (context.mounted) {
        context.go(route);
      }
    } else {
      state = AsyncError("Error null", StackTrace.empty);
      if (context.mounted) {
        showCustomSnackBar(
          context,
          content: response['message'],
          contentType: ContentType.failure,
        );
      }
    }
  }

  Future<void> loginWithMobileNumber(
    String role,
    String mobileNumber,
    BuildContext context,
  ) async {
    // state = const AsyncLoading();
    // final response = await LoginWithMobilenumberRepo.onLoginWithMobile(mobileNumber, role);
    // if (response['error'] == false) {

    //   state = AsyncData(response);

    //   if (context.mounted) {
    //     if (local.role == mainRole) {
    //       context.go(route);
    //     } else {
    //       context.go(otherUsersRoute);
    //     }
    //   }
    // } else {
    //   state = AsyncError("Error null", StackTrace.empty);
    //   if (context.mounted) {
    //     showCustomSnackBar(
    //       context,
    //       content: response['message'],
    //       contentType: ContentType.failure,
    //     );
    //   }
    // }
  }

  Future<void> verifyOTP(
    String username,
    String password,
    String selectedRole,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    final response = await LoginRepo.onLogin(username, password);
    if (response['error'] == false) {
      final local = LocalUserRefModel(
          token: response['token'],
          userId: response['userId'],
          userName: response['username'],
          role: selectedRole);
      await LoginRefDataBase().setUseretails(local);
      state = AsyncData(response);

      if (context.mounted) {
        if (local.role == mainRole) {
          context.go(route);
        } else {
          context.go(otherUsersRoute);
        }
      }
    } else {
      state = AsyncError("Error null", StackTrace.empty);
      if (context.mounted) {
        showCustomSnackBar(
          context,
          content: response['message'],
          contentType: ContentType.failure,
        );
      }
    }
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
