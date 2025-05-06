// import 'dart:developer';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:dazzles/core/components/app_loading.dart';
// import 'package:dazzles/core/components/app_margin.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/features/upload/providers/camera_notifier.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// class UploadPicturePage extends ConsumerWidget {
//   const UploadPicturePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(cameraControllerProvider);
//     final file = ref.watch(pickedFileProvider);
//     final buttonScale = ref.watch(cameraButtonControllerProvider);
//     final cameraNotifier = ref.read(cameraControllerProvider.notifier);

//     if (controller == null || !controller.value.isInitialized) {
//       return AppLoading();
//     }

//     return file != null
//         ? _buildPreviewUI(file, ref)
//         : _buildCameraUI(ref, controller, buttonScale, cameraNotifier);
//   }

//   Widget _buildPreviewUI(File file, WidgetRef ref) {
//     return SafeArea (
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//               child: Image.file(
//                 frameBuilder:
//                     (context, child, frame, wasSynchronouslyLoaded) => child,
//                 file,
//               ),
//             ),
//             AppSpacer(hp: .01),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     ref.read(pickedFileProvider.notifier).state = null;
//                   },
//                   child: const Text("Retake"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Upload logic here
//                   },
//                   child: const Text("Upload"),
//                 ),
//               ],
//             ),
//             AppSpacer(hp: .01),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCameraUI(
//     WidgetRef ref,
//     CameraController controller,
//     double buttonScale,
//     CameraNotifier notifier,
//   ) {
//     final ratio = notifier.ratio[notifier.currentRatioIndex];

//     return Center(
//       child: SizedBox(
//         height: ResponsiveHelper.hp,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             notifier.currentRatioIndex == 2
//                 ? SizedBox(
//                   height: ResponsiveHelper.hp,
//                   child: CameraPreview(controller),
//                 )
//                 : AspectRatio(
//                   aspectRatio: ratio,
//                   child: CameraPreview(controller),
//                 ),
//             _buildControls(ref, buttonScale),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControls(WidgetRef ref, double buttonScale) {
//     final cameraNotifier = ref.read(cameraControllerProvider.notifier);

//     return Positioned(
//       bottom: 40,
//       top: 20,
//       child: SafeArea(
//         child: SizedBox(
//           height: ResponsiveHelper.hp,
//           width: ResponsiveHelper.wp,
//           child: AppMargin(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Top Right Button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: cameraNotifier.toggleResolution,
//                       icon: const Icon(Icons.aspect_ratio),
//                       label: const Text("Aspect"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black.withOpacity(0.6),
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Bottom Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () => openGallery(ref),
//                       icon: const Icon(Icons.photo, color: AppColors.kWhite),
//                     ),
//                     InkWell(
//                       onTap: () => onCapture(ref),
//                       child: AnimatedScale(
//                         duration: const Duration(milliseconds: 150),
//                         scale: buttonScale,
//                         child: Container(
//                           padding: const EdgeInsets.all(40),
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.kSecondaryColor.withAlpha(60),
//                                 blurRadius: 3,
//                                 spreadRadius: 1,
//                                 offset: const Offset(3, 3),
//                               ),
//                             ],
//                             border: Border.all(
//                               color: AppColors.kWhite,
//                               width: 5,
//                             ),
//                             color: AppColors.kPrimaryColor,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: cameraNotifier.toggleCamera,
//                       icon: const Icon(
//                         CupertinoIcons.camera_rotate,
//                         color: AppColors.kWhite,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> onCapture(WidgetRef ref) async {
//     final buttonController = ref.read(cameraButtonControllerProvider.notifier);
//     final camera = ref.read(cameraControllerProvider);

//     if (buttonController.state != 0.9) {
//       buttonController.state = 0.9;

//       try {
//         final picture = await camera?.takePicture();
//         if (picture != null) {
//           ref.read(pickedFileProvider.notifier).state = File(picture.path);
//           log("Picture taken: ${picture.path}");
//         }
//       } catch (e) {
//         log("Capture error: $e");
//       } finally {
//         buttonController.state = 1.0;
//       }
//     }
//   }

//   Future<void> openGallery(WidgetRef ref) async {
//     try {
//       final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (xFile != null) {
//         ref.read(pickedFileProvider.notifier).state = File(xFile.path);
//       }
//     } catch (e) {
//       log("Gallery error: $e");
//     }
//   }
// }
