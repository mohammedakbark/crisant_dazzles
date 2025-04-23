import 'package:dazzles/features/navigation_screen.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:go_router/go_router.dart';

class RouteProvider {
  static GoRouter router = GoRouter(
    initialLocation: initialScreen,

    routes: [
      GoRoute(
        path: initialScreen,
        builder: (context, state) => NavigationScreen(),
      ),
    ],
  );
}
