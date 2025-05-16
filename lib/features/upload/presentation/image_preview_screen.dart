// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:dazzles/core/components/app_back_button.dart';
// import 'package:dazzles/core/components/app_loading.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/components/build_state_manage_button.dart';
// import 'package:dazzles/core/shared/routes/const_routes.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/shared/theme/styles/text_style.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/features/product/data/models/product_model.dart';
// import 'package:dazzles/features/upload/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
// import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// crop(Map<String, dynamic> arg) {
//   final controller = arg['controller'] as CropController;
//   controller.crop();
// }

// class PreviewScreen extends ConsumerStatefulWidget {
//   final String image;
//   final ProductModel productModel;

//   const PreviewScreen({
//     super.key,
//     required this.image,
//     required this.productModel,
//   });

//   @override
//   ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
// }

// class _PreviewScreenState extends ConsumerState<PreviewScreen> {
//   bool isCopySame = false;
//   bool imageUploading = false;

//   Uint8List? imageFile;

//   @override
//   void initState() {
//     super.initState();
//     // convert();
//     try {
//       imageFile = File(widget.image).readAsBytesSync();
//     } catch (e) {
//       log("error: $e");
//     }
//     Future.microtask(() {
//       ref.invalidate(selectAndSearchProductControllerProvider);
//       ref
//           .read(selectAndSearchProductControllerProvider.notifier)
//           .add(widget.productModel, context);
//     });
//   }

//   void _cropImage() {
//     try {
//       imageUploading = true;
//       setState(() {});
//       _cropController.crop();
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   void onCompleteCrop(CropResult value) {
//     try {
//       final container = ProviderContainer();
//       if (value is CropSuccess) {
//         if (isCopySame) {
//           context.push(copySameImageScreen, extra: value.croppedImage);
//         } else {
//           container
//               .read(uploadImageControllerProvider.notifier)
//               .uploadFunction(context, ref, value.croppedImage);
//         }
//       }
//     } catch (e) {
//       log("Error: $e");
//     } finally {
//       imageUploading = false;
//       setState(() {});
//     }
//   }

//   final _cropController = CropController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: AppBackButton(),
//         title: Text("Update image", style: AppStyle.boldStyle()),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           AppSpacer(hp: .005),
//           _buildImageView(),
//           AppSpacer(hp: .02),
//           // AppSpacer(hp: .05),
//           _buidButton(),

//           AppSpacer(hp: .02),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageView() => SizedBox(
//         height: ResponsiveHelper.hp * .75,
//         child: imageFile == null
//             ? AppLoading()
//             : FadeInDown(
//                 duration: Duration(milliseconds: 600),
//                 child: Crop(
//                     controller: _cropController,
//                     image: imageFile!,
//                     filterQuality: FilterQuality.low,
//                     fixCropRect: true,
//                     interactive: true,
//                     cornerDotBuilder: (size, edgeAlignment) => SizedBox(),
//                     baseColor: AppColors.kBgColor,
//                     aspectRatio: 9 / 16,
//                     onCropped: onCompleteCrop),
//               ),
//       );

//   _buidButton() {
//     final uploadImageState = ref.watch(uploadImageControllerProvider);
//     final productSelectionState = ref.watch(
//       selectAndSearchProductControllerProvider,
//     );
//     return AnimatedSwitcher(
//       duration: Duration(milliseconds: 300),
//       switchInCurve: Curves.easeIn,
//       switchOutCurve: Curves.easeOut,
//       transitionBuilder: (Widget child, Animation<double> animation) {
//         return FadeTransition(
//           opacity: animation,
//           child: ScaleTransition(scale: animation, child: child),
//         );
//       },
//       child: imageUploading
//           ? AppLoading()
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ZoomIn(
//                   duration: Duration(milliseconds: 700),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       isCopySame = true;
//                       _cropImage();
//                     },
//                     icon: Icon(Icons.copy, color: AppColors.kWhite),
//                     label: Text(
//                       "Copy same",
//                       style: AppStyle.normalStyle(color: AppColors.kWhite),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.kTeal,
//                       foregroundColor: AppColors.kWhite,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 14,
//                       ),
//                       textStyle: const TextStyle(fontSize: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                     ),
//                   ),
//                 ),
//                 ZoomIn(
//                   duration: Duration(milliseconds: 700),
//                   child: BuildStateManageComponent(
//                     stateController: uploadImageState,
//                     successWidget: (data) => ElevatedButton.icon(
//                       onPressed: productSelectionState.selectedIds.isNotEmpty
//                           ? () {
//                               isCopySame = false;
//                               _cropImage();
//                             }
//                           : null,
//                       icon: Icon(
//                         Icons.cloud_upload_outlined,
//                         color: AppColors.kWhite,
//                       ),
//                       label: Text(
//                         "Upload",
//                         style: AppStyle.normalStyle(
//                           color: AppColors.kWhite,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.kGreen,
//                         foregroundColor: AppColors.kWhite,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 14,
//                         ),
//                         textStyle: const TextStyle(fontSize: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
