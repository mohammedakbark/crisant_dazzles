import 'dart:io';

import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/module/Auth/presentation/login_screen.dart';
import 'package:dazzles/module/driver/check%20in/presentation/driver_user_reg_screen.dart';
import 'package:dazzles/module/driver/check%20out/presentation/dr_location_screen.dart';
import 'package:dazzles/module/driver/driver_nav_screen.dart';
import 'package:dazzles/module/driver/home/data/model/dr_check_out_valet_info_model.dart';
import 'package:dazzles/module/driver/home/presentation/driver_qr_scanner_screen.dart';
import 'package:dazzles/module/office/camera/presentation/products_selection_screen.dart';
import 'package:dazzles/module/office/home/presentation/view_all_recent_captured_screen.dart';
import 'package:dazzles/module/office/navigation_screen.dart';
import 'package:dazzles/module/office/notification/presentation/notification_screen.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';
import 'package:dazzles/module/office/product/presentation/view_and_edit_product.dart';
import 'package:dazzles/module/office/product/presentation/widgets/product_image_view.dart';
import 'package:dazzles/module/office/purchase%20orders/presentation/po_product_screen.dart';
import 'package:dazzles/module/office/upload%20failed/presentation/failed_data_screen.dart';
import 'package:dazzles/module/other%20roles%20modules/other_users_navigationScreen.dart';
import 'package:dazzles/module/splash_screen.dart';
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
        path: poProductsScreen,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final id = map['id'] as String;
          final supplier = map['supplier'] as String;
          return PoProductScreen(
            id: id,
            supplier: supplier,
          );
        },
      ),



      // DRIVER ROLE ROUTES

      GoRoute(
          path: drNavScreen, builder: (context, state) => DriverNavScreen()),

      GoRoute(
          path: drQrScannerScreen,
          builder: (context, state) {
            final map = state.extra as Map<String, dynamic>;
            final scanFor = map["scanFor"];
            return DriverQRScannerPage(
              scanFor: scanFor,
            );
          }),
      GoRoute(
          path: drCustomerRegScreen,
          builder: (context, state) {
            final map = state.extra as Map<String, dynamic>;
            final qrId = map["qrId"];
            return DriverCustomerRegScreen(
              qrId: qrId,
            );
          }),

      GoRoute(
          path: drlocationScreen,
          builder: (context, state) {
            final map = state.extra as Map<String, dynamic>;
            final model = map['modelData'] as Map<String, dynamic>;
            return DrVehicleLocationScreen(

            valetInfo: DrCheckOutValetInfoModel.fromJson(model),
            );
          }),

      // OTHER ROLE ROUTES

      GoRoute(
          path: otherUsersRoute,
          builder: (context, state) => OtherUsersNaviagationScreen()),

      GoRoute(
          path: notificationScreen,
          builder: (context, state) => NotificationScreen()),
    ],
  );
}
