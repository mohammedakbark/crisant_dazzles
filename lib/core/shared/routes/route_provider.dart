import 'dart:io';

import 'package:dazzles/office/auth/presentation/login_screen.dart';
import 'package:dazzles/office/camera/presentation/products_selection_screen.dart';
import 'package:dazzles/office/home/presentation/view_all_recent_captured_screen.dart';
import 'package:dazzles/office/navigation_screen.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/office/notification/presentation/notification_screen.dart';
import 'package:dazzles/office/upload%20failed/presentation/failed_data_screen.dart';
import 'package:dazzles/office/product/data/models/product_model.dart';
import 'package:dazzles/office/product/presentation/view_and_edit_product.dart';
import 'package:dazzles/office/product/presentation/widgets/product_image_view.dart';
import 'package:dazzles/office/role_based_files/other_users_navigationScreen.dart';
import 'package:dazzles/office/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteProvider {
  static GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialScreen,
    routes: [
      GoRoute(path: initialScreen, builder: (context, state) => SplashScreen()),
      GoRoute(path: loginScreen, builder: (context, state) => LoginScreen()),
      // GoRoute(path: otpScreen, builder: (context, state) {
      //   final mapData=state.extra as Map;

      //   final mobileNumber=mapData['mobileNumber'];
      //   final role=mapData['role'];
      //   return OtpScreen(mobileNumber: mobileNumber,role: role,);
      // }),
      GoRoute(path: route, builder: (context, state) => NavigationScreen()),

      GoRoute(
        path: uploadFialedScreen,
        builder: (context, state) => UploadFaieldDataScreen(),
      ),
      GoRoute(
        path: recentlyCaptured,
        builder: (context, state) => ViewAllRecentCapturedScreen(),
      ),
      GoRoute(
        path: productsSelectionScreen,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final file = map['file'] as File;
          return ProductSelectionScreen(
            fileImage: file,
          );
        },
      ),
      GoRoute(
        path: openImage,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final path = map['path'];
          final tag = map['heroTag'] ?? "heroTag";
          bool enableEditButton = map['enableEditButton'] ?? false;
          final prouctModel = map['prouctModel'] as ProductModel?;
          return ImageViewScreen(
            heroTag: tag,
            image: path!,
            productModel: prouctModel,
            enableEditButton: enableEditButton,
          );
        },
      ),
      GoRoute(
        path: viewAndEditProductScreen,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final id = map['id'] as int;
          final productName = map['productName'] as String;
          return ViewAndEditProductScreen(
            productId: id,
            productName: productName,
          );
        },
      ),

      GoRoute(
          path: notificationScreen,
          builder: (context, state) => NotificationScreen()),

      // OTHER ROLE ROUTES

      GoRoute(
          path: otherUsersRoute,
          builder: (context, state) => OtherUsersNaviagationScreen()),

      // W E B  V I E W   R O U T E

      // GoRoute(path: webViewScreen, builder: (context, state) => WebViewScreen()),
      //  GoRoute(path: decisionScreen, builder: (context, state) => DecisionScreen())
    ],
  );
}
