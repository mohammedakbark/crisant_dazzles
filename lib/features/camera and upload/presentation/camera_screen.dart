import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/services/office_navigation_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/camera%20and%20upload/data/providers/camera%20controller/camera_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

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
    final isTab = ResponsiveHelper.isTablet();
    initializeControllerFuture =
        ref.read(cameraControllerProvider.notifier).initCamera();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: AppBackButton(),
      ),
      body: FutureBuilder(
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
                        bottom: 0,
                        left: 10,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => ref
                                    .read(cameraControllerProvider.notifier)
                                    .pickFromGallery(context),
                                icon: Icon(
                                  size: ResponsiveHelper.isTablet() ? 50 : null,
                                  CupertinoIcons.photo_on_rectangle,
                                  color: AppColors.kWhite,
                                )),
                          ],
                        ),
                      )
                    ],
                  ));
            } else {
              return Center(child: AppLoading());
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: () async {
          log("Pressed...");
          // if (ref.watch(officeNavigationController) == 2) {
          ref.watch(camaraButtonScaleController.notifier).state = 0.9;
          await Future.delayed(Duration(microseconds: 500));
          ref.watch(camaraButtonScaleController.notifier).state = 1.0;
          await ref.read(cameraControllerProvider.notifier).takePhoto(context);
          // } else {
          //   ref
          //       .watch(officeNavigationController.notifier)
          //       .state = 2;
          // }
        },
        child: AnimatedScale(
          scale: ref.watch(camaraButtonScaleController),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Container(
            width: isTab ? ResponsiveHelper.wp * .3 : ResponsiveHelper.wp * .3,
            height:
                isTab ? ResponsiveHelper.wp * .13 : ResponsiveHelper.wp * .18,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    width: 4,
                    color:
                        ref.watch(officeNavigationController.notifier).state ==
                                2
                            ? AppColors.kPrimaryColor
                            : AppColors.kWhite),
                shape: BoxShape.circle),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: AppColors.kSecondaryColor,
                    // color: ref
                    //             .watch(navigationController.notifier)
                    //             .state ==
                    //         2
                    //     ? AppColors.kWhite
                    //     : AppColors.kSecondaryColor
                  ),
                  color:
                      ref.watch(officeNavigationController.notifier).state == 2
                          ? AppColors.kPrimaryColor
                          : AppColors.kWhite,
                  shape: BoxShape.circle),
              child: Icon(
                size: isTab ? 40 : null,
                CupertinoIcons.camera_fill,
                color: ref.watch(officeNavigationController.notifier).state == 2
                    ? AppColors.kWhite
                    : AppColors.kBgColor,
              ),
            ),
          ),
        ),
      ),
    );

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
