import 'dart:io';
import 'dart:typed_data';

import 'package:dazzles/features/auth/presentation/login_screen.dart';
import 'package:dazzles/features/home/presentation/view_all_recent_captured_screen.dart';
import 'package:dazzles/features/navigation_screen.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/notification/presentation/notification_screen.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/presentation/widgets/product_image_view.dart';
import 'package:dazzles/features/splash_screen.dart';
import 'package:dazzles/features/upload/presentation/copy_more_produtcs_screen.dart';
import 'package:dazzles/features/upload/presentation/image_preview_screen.dart';
import 'package:go_router/go_router.dart';

class RouteProvider {
  static GoRouter router = GoRouter(
    initialLocation: initialScreen,

    routes: [
      GoRoute(path: initialScreen, builder: (context, state) => SplashScreen()),
      GoRoute(path: loginScreen, builder: (context, state) => LoginScreen()),
      GoRoute(path: route, builder: (context, state) => NavigationScreen()),

      GoRoute(
        path: notificationScreen,
        builder: (context, state) => NotificationScreen(),
      ),

      GoRoute(
        path: recentlyCaptured,
        builder: (context, state) => ViewAllRecentCapturedScreen(),
      ),
      GoRoute(
        path: imagePreview,

        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final productModel = map['productModel'] as ProductModel;
          final image = map['path'] as String;
          return PreviewScreen(image: image, productModel: productModel);
        },
      ),

      GoRoute(
        path: copySameImageScreen,

        builder: (context, state) {
          final file = state.extra as Uint8List;
          // final id = map['id'] as int;
          // final path = map['path'] as String;
          return CopyMoreProdutcsScreen(fileImage: file);
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
    ],
  );
}
