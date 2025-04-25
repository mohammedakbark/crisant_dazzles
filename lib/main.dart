import 'package:camera/camera.dart';
import 'package:dazzles/core/shared/routes/route_provider.dart';
import 'package:dazzles/core/shared/theme/app_theme.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/upload/providers/camera_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); // Get available cameras
  

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ResponsiveHelper.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dazzles',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(),
      routerConfig: RouteProvider.router,
    );
  }
}
