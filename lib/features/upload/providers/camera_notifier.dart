import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<CameraDescription> cameras;

class CameraNotifier extends StateNotifier<CameraController?> {
  CameraNotifier() : super(null) {
    initializeCamera();
  }

  bool _enableFrontCamera = false;
  int _currentRatioIndex = 2;
  final List<double> ratio = [1, 9 / 12, 0]; // Can be updated later

  int get currentRatioIndex => _currentRatioIndex;

  Future<void> initializeCamera() async {
    try {
      log('initializing......');
      await state?.dispose();
      final controller = CameraController(
        _enableFrontCamera ? cameras[1] : cameras[0],
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );

      await controller.initialize();
      state = controller;
    } catch (e, stackTrace) {
      log("Error while initializing camera: $e", stackTrace: stackTrace);
    }
  }

  Future<void> toggleCamera() async {
    _enableFrontCamera = !_enableFrontCamera;
    await state?.dispose();
    await initializeCamera();
  }

  Future<void> toggleResolution() async {
    _currentRatioIndex = (_currentRatioIndex + 1) % ratio.length;
    await state?.dispose();
    await initializeCamera();
  }

  @override
  void dispose() {
    state?.dispose();
    log('disposed');
    super.dispose();
  }
}

final cameraControllerProvider =
    StateNotifierProvider.autoDispose<CameraNotifier, CameraController?>(
      (ref) => CameraNotifier(),
    );

final cameraButtonControllerProvider = StateProvider<double>((ref) => 1.0);
final pickedFileProvider = StateProvider<File?>((ref) => null);
