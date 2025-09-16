import 'dart:async';
import 'dart:io';

import 'package:dazzles/core/services/driver_nav_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/utils/app_bottom_sheet.dart';
import 'package:dazzles/features/valey/check%20out/data/repo/dr_final_video_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DriverCheckOutController extends AsyncNotifier<Map<String, dynamic>> {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {};
  }

  File? _pickedVideoFile;

  Future<void> onTakeVideo(
    BuildContext context,
    String valetId,
  ) async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );

    if (pickedFile != null) {
      _pickedVideoFile = File(pickedFile.path);
      await _onUploadVideo(context, _pickedVideoFile!, valetId);
    }
  }

  Future<void> _onUploadVideo(
      BuildContext context, File videoFile, String valetId) async {
    try {
      state = AsyncValue.loading();
      final response = await DriverUploadFinalVideoRepo.onUploadFinalVideo(
          videoFile, valetId);
      if (response['error'] == false) {
        state = AsyncValue.data({});
        showCustomBottomSheet(
          message: "Final video uploaded successfully.",
          subtitle: "You can now deliver this car to the customer.",
          buttonText: "GO TO DASHBOARD",
          onNext: () {
            ref.watch(driverNavigationController.notifier).state = 0;
            context.go(drNavScreen);
          },
        );
      } else {
        state = AsyncValue.error(response['data'], StackTrace.empty);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final driverCheckOutControllerProvider =
    AsyncNotifierProvider<DriverCheckOutController, Map<String, dynamic>>(
        DriverCheckOutController.new);
