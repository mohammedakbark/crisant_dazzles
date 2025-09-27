import 'dart:io';

import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/Auth/presentation/login_screen.dart';
import 'package:dazzles/features/navigation/presentation/pending_image_screen.dart';
import 'package:dazzles/features/navigation/presentation/upcoming_products_screen.dart';
import 'package:dazzles/features/operation-or-task/presentation/create_new_operation_task_screen.dart';
import 'package:dazzles/features/operation-or-task/presentation/operation_task_view_scree.dart';
import 'package:dazzles/features/operation-or-task/presentation/task_perfomance_screen.dart';
import 'package:dazzles/features/packaging-or-po/presentation/package_page.dart';
import 'package:dazzles/features/product/presentation/products_page.dart';
import 'package:dazzles/features/route_sreen.dart';
import 'package:dazzles/features/scan%20product/data/model/scanned_product_model.dart';
import 'package:dazzles/features/scan%20product/screen/presentation/qr_scan_screen.dart';
import 'package:dazzles/features/scan%20product/screen/presentation/scanned_product_screen.dart';
import 'package:dazzles/features/valey/check%20in/presentation/driver_user_reg_screen.dart';
import 'package:dazzles/features/valey/check%20out/presentation/dr_location_screen.dart';
import 'package:dazzles/features/valey/driver_nav_screen.dart';
import 'package:dazzles/features/valey/home/data/model/dr_check_out_valet_info_model.dart';
import 'package:dazzles/features/valey/home/presentation/driver_qr_scanner_screen.dart';
import 'package:dazzles/features/valey/parked%20cars/presentation/driver_video_player_screen.dart';
import 'package:dazzles/features/camera%20and%20upload/presentation/camera_screen.dart';
import 'package:dazzles/features/camera%20and%20upload/presentation/products_selection_screen.dart';
import 'package:dazzles/features/recently%20uploded/presentation/view_all_recent_captured_screen.dart';
import 'package:dazzles/features/notification/presentation/notification_screen.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/presentation/view_and_edit_product.dart';
import 'package:dazzles/features/product/presentation/widgets/product_image_view.dart';
import 'package:dazzles/features/packaging-or-po/presentation/po_product_screen.dart';
import 'package:dazzles/features/upload%20failed/presentation/failed_data_screen.dart';
import 'package:dazzles/features/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteProvider {
  static GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialScreen,
    routes: [
      GoRoute(
          path: initialScreen,
          builder: (context, state) => UpgradeAlert(
              barrierDismissible: false, // user can’t close dialog
              showLater: false,
              showIgnore: false,
              dialogStyle: Platform.isAndroid
                  ? UpgradeDialogStyle.material
                  : UpgradeDialogStyle.cupertino,
              child: SplashScreen())),
      GoRoute(path: loginScreen, builder: (context, state) => LoginScreen()),

      // ==  ---- PERMISSION BASE ROUTE

      GoRoute(path: routeScreen, builder: (context, state) => RouteScreen()),

      GoRoute(
        path: uploadFialedScreen,
        builder: (context, state) => UploadFaieldDataScreen(),
      ),

      GoRoute(
          path: notificationScreen,
          builder: (context, state) => NotificationScreen()),
      GoRoute(path: qrScanScreen, builder: (context, state) => QrScanScreen()),
      GoRoute(
          path: scannedProductDetailScreen,
          builder: (context, state) {
            final detials = state.extra as Map<String, dynamic>;

            return ScannedProductScreen(
                productDataModel: ScannedProductModel.fromJson(detials));
          }),

      GoRoute(
          path: imagePendingScreen,
          builder: (context, state) => PendingImageScreen()),
      GoRoute(
          path: upcomingProductsScreen,
          builder: (context, state) => UpcomingProductsScreen()),

      // PO LEVEL

      GoRoute(
          path: packageSuppliers, builder: (context, state) => PackagePage()),

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

      // PRODUCT :LEVEL

      GoRoute(path: productslist, builder: (context, state) => ProductsPage()),

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
        path: recentlyCaptured,
        builder: (context, state) => ViewAllRecentCapturedScreen(),
      ),

      // BULK UPDATE

      GoRoute(
        path: cameraScreen,
        builder: (context, state) => CameraScreen(),
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
        path: productsSelectionScreen,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final file = map['file'] as File;
          return ProductSelectionScreen(
            fileImage: file,
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

      GoRoute(
          path: drVideoPlayerScreen,
          builder: (context, state) {
            final map = state.extra as Map<String, dynamic>;
            final initialVideo = map['initialVideo'] as String?;
            final finalVideo = map['finalVideo'] as String?;
            final videos = [
              if (initialVideo != null)
                {"title": "Initial Video", "file": initialVideo},
              if (finalVideo != null)
                {"title": "Final Video", "file": finalVideo}
            ];

            return DriverVideoPlayerScreen(
              videos: videos,
            );
          }),

      //---------------------------

      // ---- Operation Level Task

      GoRoute(
          path: operationTaskViewScreen,
          builder: (context, state) {
            return OperationTaskViewScreen();
          }),
      GoRoute(
          path: creatNewOperationTaskScreen,
          builder: (context, state) {
            return CreateNewOperationTaskScreen();
          }),
      GoRoute(
          path: taskPerfomanceScreen,
          builder: (context, state) {
            final map = state.extra as Map<String, dynamic>;
            final id = map['operationId'] as String;
            return TaskPerfomanceScreen(operationId: id,);
          }),
    ],
  );
}
