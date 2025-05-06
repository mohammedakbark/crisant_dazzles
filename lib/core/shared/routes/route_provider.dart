import 'package:dazzles/features/auth/presentation/login_screen.dart';
import 'package:dazzles/features/home/presentation/view_all_recent_captured_screen.dart';
import 'package:dazzles/features/navigation_screen.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/notification/presentation/notification_screen.dart';
import 'package:dazzles/features/splash_screen.dart';
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
          final imagePath = state.extra as String;
          return PreviewScreen(imagePath: imagePath);
        },
      ),
    ],
  );
}
