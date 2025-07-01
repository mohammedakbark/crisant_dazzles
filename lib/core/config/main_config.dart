import 'package:camera/camera.dart';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/office/camera/data/providers/camera_controller.dart';
import 'package:dazzles/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
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
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> lockOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

      // Add `DeviceOrientation.portraitDown` if you want upside down too
    ]);
  }
}
