import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/camera/data/providers/camera_controller_state.dart';
import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> cameras;

class CamerasController extends AsyncNotifier<CameraControllerState> {
  late CameraController cameraController;

  @override
  FutureOr<CameraControllerState> build() async {
    try {
      state = AsyncValue.loading();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.external,
        orElse: () => cameras.first, // fallback
      );
      cameraController = CameraController(backCamera, ResolutionPreset.max);
      await cameraController.initialize();
      return CameraControllerState(cameraController: cameraController);
    } catch (e, trace) {
      throw AsyncValue.error(e, trace);
    }
  }

  @override
  void dispose() {
    cameraController.dispose(); // Properly dispose here
  }

  Future<void> takePhoto(BuildContext context) async {
    final xFile = await cameraController.takePicture();
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
    AsyncNotifierProvider<CamerasController, CameraControllerState>(
  () => CamerasController(),
);
