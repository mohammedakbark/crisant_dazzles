import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/camera/data/providers/camera_controller.dart';
import 'package:dazzles/features/camera/data/providers/camera_controller_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? _cameraController;

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraControllerProvider);
    final cameraController = ref.read(cameraControllerProvider.notifier);
    return BuildStateManageComponent(
      stateController: cameraState,
      successWidget: (data) {
        log("message");
        final state = data as CameraControllerState;
        return AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(state.cameraController),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () =>
                              cameraController.pickFromGallery(context),
                          icon: Icon(
                            CupertinoIcons.photo_on_rectangle,
                            color: AppColors.kWhite,
                          ))
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
