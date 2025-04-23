import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/upload/providers/camera_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadPicturePage extends ConsumerWidget {
  const UploadPicturePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cameraController = ref.watch(cameraControllerProvider);
    final buttonController = ref.watch(cameraButtonControllerProvider);

    return cameraController == null || !cameraController.value.isInitialized
        ? AppLoading()
        : Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: ResponsiveHelper.hp,
              child: CameraPreview(cameraController),
            ),
            Positioned(
              bottom: 40,
              top: 20,
              child: SafeArea(
                child: SizedBox(
                  height: ResponsiveHelper.hp,
                  width: ResponsiveHelper.wp,
                  child: AppMargin(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.photo, color: AppColors.kWhite),
                            ),

                            ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(cameraControllerProvider.notifier)
                                    .toggleResolution();
                              },
                              icon: Icon(Icons.aspect_ratio),
                              label: Text("Toggle Aspect Ratio"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.6),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.photo, color: AppColors.kWhite),
                            ),
                            InkWell(
                              onTap: () => onClick(ref),
                              child: AnimatedScale(
                                duration: Duration(milliseconds: 150),
                                scale: buttonController,
                                child: Container(
                                  padding: EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.kSecondaryColor
                                            .withAlpha(60),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppColors.kWhite,
                                      width: 5,
                                    ),
                                    color: AppColors.kPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(cameraControllerProvider.notifier)
                                    .toggleCamera();
                              },
                              icon: Icon(
                                CupertinoIcons.camera_rotate,
                                color: AppColors.kWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }

  onClick(WidgetRef ref) async {
    final cameraController = ref.read(cameraControllerProvider);
    final cameraButtonController = ref.read(
      cameraButtonControllerProvider.notifier,
    );
    cameraButtonController.state = 0.9;
    final picture = await cameraController?.takePicture();
    log(picture!.path.toString());
    cameraButtonController.state = 1.0;
  }
}
