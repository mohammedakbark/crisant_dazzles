import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/camera/data/providers/camera_controller_state.dart';
import 'package:dazzles/features/pending/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> cameras;

class CamerasController extends AsyncNotifier<Map<String, dynamic>> {
   CameraController? cameraController;

  @override
  FutureOr<Map<String, dynamic>> build() async {
    
    return {};
  }

  Future<void> initCamera() async {
    if(cameras.isEmpty)return;
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    return await cameraController!.initialize();
  }

  

  Future<void> takePhoto(BuildContext context) async {
    if(cameraController==null)return;
    final xFile = await cameraController!.takePicture();
    final croppedFile = await UploadImageNotifier.cropImageSettings(xFile.path);
    if (croppedFile != null) {
      context.push(productsSelectionScreen,
          extra: {"file": File(croppedFile.path)});
    }
  }

  Future<void> pickFromGallery(BuildContext context) async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final croppedFile =
          await UploadImageNotifier.cropImageSettings(xFile.path);
      if (croppedFile != null) {
        context.push(productsSelectionScreen,
            extra: {"file": File(croppedFile.path)});
      }
    }
  }
}

final cameraControllerProvider =
    AsyncNotifierProvider<CamerasController, Map<String, dynamic>>(
  () => CamerasController(),
);
