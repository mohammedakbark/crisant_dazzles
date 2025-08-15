import 'package:camera/camera.dart';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/module/office/camera%20and%20upload/data/providers/camera%20controller/camera_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class MainConfig {
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(UploadPhotoModelAdapter());
    await Hive.openBox<UploadPhotoModel>(UploadManager.db);
  }

  static initCameraService() async {
    cameras = await availableCameras();
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
        //  options: DefaultFirebaseOptions.currentPlatform,
        );
  }

  static Future<void> lockOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

      // Add `DeviceOrientation.portraitDown` if you want upside down too
    ]);
  }

  // static Future<void> loadEnv() async {
  //   try {
  //     await dotenv.load(); // Load env file
  //   } catch (e) {}
  // }
}
