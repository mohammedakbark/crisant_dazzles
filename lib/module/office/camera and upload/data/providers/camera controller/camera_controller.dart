import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/camera%20and%20upload/data/providers/upload_image_controller.dart';
import 'package:dazzles/module/office/camera%20and%20upload/presentation/widget/image_source_sheet.dart';
import 'package:dazzles/module/office/camera%20and%20upload/presentation/widget/logo_color_selection_tile.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20po%20products/get_po_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> cameras;

class CamerasController extends AsyncNotifier<Map<String, dynamic>> {
  CameraController? cameraController;

  @override
  FutureOr<Map<String, dynamic>> build() async {
    return {};
  }

  Future<void> initCamera() async {
    if (cameras.isEmpty) return;
    cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    return await cameraController!.initialize();
  }

  Future<void> takePhoto(BuildContext context) async {
    if (cameraController == null) return;
    final xFile = await cameraController!.takePicture();
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
    AsyncNotifierProvider<CamerasController, Map<String, dynamic>>(
  () => CamerasController(),
);

void showGallerySheet(BuildContext context, WidgetRef ref,
    {ProductModel? productModel, String? supplierId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return AnimatedPadding(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SlideInUp(
          duration: Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source',
                  style: AppStyle.mediumStyle(
                    fontSize: ResponsiveHelper.isTablet() ? 40 : 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                LogoColorSelectionTile(),
                Row(
                  children: [
                    Expanded(
                      child: ZoomIn(
                        duration: Duration(milliseconds: 600),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kDeepPurple,
                            foregroundColor: AppColors.kWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            final logoColor =
                                ref.read(logoColorSelctionControllerProvider);
                            if (supplierId != null) {
                              // For Updating PO Images

                              final controller = ref
                                  .read(getAllPoProductsControllerProvider(
                                      supplierId!))
                                  .value;
                              if (controller != null) {
                                UploadImageNotifier()
                                    .pickImageAndUploadForSupplier(
                                        context,
                                        ImageSource.gallery,
                                        ref,
                                        controller.selectedIds,
                                        supplierId!,
                                        logoColor);
                              }
                            }
                            if (productModel != null) {
                              // For Updating  Product Images
                              UploadImageNotifier()
                                  .pickImageAndUploadForProducts(
                                      context,
                                      ImageSource.gallery,
                                      productModel!,
                                      ref,
                                      logoColor);
                            }
                          },
                          icon: Icon(
                              size: ResponsiveHelper.isTablet() ? 30 : null,
                              Icons.photo,
                              color: AppColors.kWhite),
                          label: Text(
                            "Gallery",
                            style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.isTablet() ? 30 : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ZoomIn(
                        duration: Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kTeal,
                            foregroundColor: AppColors.kWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            final logoColor =
                                ref.read(logoColorSelctionControllerProvider);
                            if (supplierId != null) {
                              // For Updating PO Images
                              UploadImageNotifier()
                                  .pickImageAndUploadForSupplier(
                                      context,
                                      ImageSource.camera,
                                      ref,
                                      ref
                                          .read(
                                              getAllPoProductsControllerProvider(
                                                  supplierId!))
                                          .value!
                                          .selectedIds,
                                      supplierId!,
                                      logoColor);
                            }
                            if (productModel != null) {
                              // For Updating  Product Images
                              UploadImageNotifier()
                                  .pickImageAndUploadForProducts(
                                      context,
                                      ImageSource.camera,
                                      productModel!,
                                      ref,
                                      logoColor);
                            }
                          },
                          icon: Icon(
                            size: ResponsiveHelper.isTablet() ? 30 : null,
                            Icons.camera_alt,
                            color: AppColors.kWhite,
                          ),
                          label: Text(
                            "Camera",
                            style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.isTablet() ? 30 : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
