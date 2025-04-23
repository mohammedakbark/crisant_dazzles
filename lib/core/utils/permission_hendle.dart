import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<void> requestPermissions() async {
    await handleCameraPermission();
  }

  static Future<bool> handleCameraPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.camera,
          Permission.photos, // For iOS
          Permission.storage, // For Android below API 33
        ].request();

    if (statuses[Permission.camera]!.isDenied ||
        statuses[Permission.storage]!.isDenied) {
      print("Permission denied! Request again.");
      return false;
    } else {
      print("All permissions granted!");
      return true;
    }
  }
}
