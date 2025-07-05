import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<void> requestPermissions() async {
    await handleCameraPermission();
  }

  static Future<bool> handleCameraPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos, // For iOS
      Permission.storage, // For Android below API 33
    ].request();

    if (statuses[Permission.camera]!.isDenied ||
        statuses[Permission.storage]!.isDenied) {
      log("Permission denied! Request again.");
      return false;
    } else {
      log("All permissions granted!");
      return true;
    }
  }

 static Future<bool> askLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not enabled, open location settings and return false
      await Geolocator.openLocationSettings();
      return false;
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, return false
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission denied forever, open app settings
      await Geolocator.openAppSettings();
      return false;
    }

    // Permission granted
    return true;
  }
}
