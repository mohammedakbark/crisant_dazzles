import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/camera/data/providers/camera_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late Future<void> initializeControllerFuture;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeControllerFuture =
        ref.read(cameraControllerProvider.notifier).initCamera();
    return FutureBuilder(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          log("Loding");
          if (snapshot.connectionState == ConnectionState.done) {
            final notifier = ref.watch(cameraControllerProvider.notifier);
            return AspectRatio(
                aspectRatio: 9 / 16,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    notifier.cameraController != null
                        ? CameraPreview(notifier.cameraController!)
                        : AppErrorView(error: "Camara is not availabe!"),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => ref
                                  .read(cameraControllerProvider.notifier)
                                  .pickFromGallery(context),
                              icon: Icon(
                                size: ResponsiveHelper.isTablet()?50:null,
                                CupertinoIcons.photo_on_rectangle,
                                color: AppColors.kWhite,
                              ))
                        ],
                      ),
                    )
                  ],
                ));
          } else {
            return Center(child: AppLoading());
          }
        });
    // SizedBox( child: Center(child: Text("data"),),);
    //     BuildStateManageComponent(
    //   stateController: ref.watch(cameraControllerProvider),
    //   errorWidget: (p0, p1) =>
    //       SingleChildScrollView(child: AppErrorView(error: p0.toString())),
    //   successWidget: (data) {
    //     log("message");
    //     final state = data as CameraControllerState?;

    //     return state == null
    //         ? AppErrorView(error: "Camera not availabe")
    //         : AspectRatio(
    //             aspectRatio: 9 / 16,
    //             child: Stack(
    //               // fit: StackFit.expand,
    //               children: [
    //                 CameraPreview(state.cameraController),
    //                 Positioned(
    //                   bottom: 10,
    //                   left: 10,
    //                   child: Row(
    //                     children: [
    //                       IconButton(
    //                           onPressed: () => ref
    //                               .read(cameraControllerProvider.notifier)
    //                               .pickFromGallery(context),
    //                           icon: Icon(
    //                             CupertinoIcons.photo_on_rectangle,
    //                             color: AppColors.kWhite,
    //                           ))
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ));
    //   },
    // );
  }
}
