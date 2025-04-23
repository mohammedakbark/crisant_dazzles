import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<CameraDescription> cameras;

class CameraNotifier extends StateNotifier<CameraController?> {
  CameraNotifier() : super(null) {
    initializeCamera();
  }
  bool _enableFrontCamera = false;
  final List<ResolutionPreset> _presets = [
    ResolutionPreset.low,
    ResolutionPreset.medium,
    ResolutionPreset.high,
    ResolutionPreset.veryHigh,
    ResolutionPreset.ultraHigh,
    ResolutionPreset.max,
  ];

  int _currentPresetIndex = 2; // Start from high (1280x720)

  Future<void> initializeCamera() async {
    try {
      final rearCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      final controller = CameraController(
        _enableFrontCamera ? frontCamera : rearCamera,
        _presets[_currentPresetIndex],
        enableAudio: false,
      );
      await controller.initialize();
      state = controller;
    } catch (e) {
      log("Error while initializing camera");
    }
  }

  void toggleCamera() async {
    _enableFrontCamera = !_enableFrontCamera;
    await initializeCamera();
  }

  void toggleResolution() async {
    _currentPresetIndex = (_currentPresetIndex + 1) % _presets.length;
    await initializeCamera();
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

final cameraControllerProvider =
    StateNotifierProvider<CameraNotifier, CameraController?>(
      (ref) => CameraNotifier(),
    );

final cameraButtonControllerProvider = StateProvider<double>((ref) => 1.0);
