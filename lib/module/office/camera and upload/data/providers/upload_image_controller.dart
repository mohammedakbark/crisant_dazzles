import 'dart:developer';
import 'dart:io';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/core/services/office_navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/module/office/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';
import 'package:dazzles/module/office/camera%20and%20upload/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/module/office/product/data/repo/upload_image_from_product_repo.dart';
import 'package:dazzles/module/office/packaging/data/repo/update_image_from_po_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UploadImageNotifier extends AsyncNotifier<Map<String, dynamic>> {
  static Future<CroppedFile?> cropImageSettings(
    String imagePath,
  ) {
    return ImageCropper().cropImage(
        sourcePath: imagePath,
        maxWidth: 1920,
        maxHeight: 1080,
        compressQuality: 90,
        aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.kPrimaryColor,
            toolbarWidgetColor: AppColors.kBgColor,
            lockAspectRatio: true,
            statusBarColor: AppColors.kPrimaryColor,
            hideBottomControls: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          )
        ]);
  }

// ---------------------  UPLOAD IMAGE From PRODUCT PAGE

  Future<void> _uploadImage(
      List<int> ids,
      String path,
      UploadManager uploadManagerController,
      bool isFromProducts,
      String logo) async {
    showCustomSnackBarAdptive("Uploading...");
    Map<String, dynamic> response = {};
    if (isFromProducts) {
      response =
          await UploadImageFromProductRepo.onUploadImage(ids, path, logo);
    } else {
      response = await UploadImageFromPORepo.onUploadImage(ids, path, logo);
    }

    log(response['data']);
    if (response['error'] == false) {
      showCustomSnackBarAdptive("Uploaded successful", isError: false);
    } else {
      showCustomSnackBarAdptive("Uploading failed!", isError: true);
      // state = AsyncError(response['data'].toString(), StackTrace.empty);
      uploadManagerController.addToUplods(UploadPhotoModel(
        logoColor: logo,
        failedReason: response['data'].toString(),
        ids: ids,
        imagePath: path,
        isUploadSuccess: false,
      ));
    }
  }

// IMAGE PICKER WITH SINGLE IMAGE UPLOAD FUNCTION  (NO USING NOW)
  Future<void> pickImageAndUploadForProducts(
      BuildContext context,
      ImageSource source,
      ProductModel productModel,
      WidgetRef ref,
      String logoColor) async {
    final uploadManagerController = ref.read(uploadManagerProvider.notifier);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );
      if (context.mounted && pickedFile != null) {
        context.pop();

        final _croppedFile = await cropImageSettings(
          pickedFile.path,
        );
        if (_croppedFile != null) {
          _uploadImage([productModel.id], _croppedFile.path,
              uploadManagerController, true, logoColor);
          ref.invalidate(dashboardControllerProvider);
          ref.read(officeNavigationController.notifier).state = 0;
          context.go(route);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

//  uploading  multiple ids
  Future<void> uploadMultipleIdsForProducts(
      BuildContext context, WidgetRef ref, File image, String logoColor) async {
    state = AsyncLoading();
    final idsState = ref.read(selectAndSearchProductControllerProvider);
    final uploadManagerController = ref.read(uploadManagerProvider.notifier);
    List<int> ids = [];
    for (var i in idsState.selectedIds) {
      ids.add(i.id);
    }
    _uploadImage(ids, image.path, uploadManagerController, true, logoColor);
    ref.invalidate(dashboardControllerProvider);
    ref.read(officeNavigationController.notifier).state = 0;
    context.go(route);
  }

  // -------------------  UPLOAD IMAGE FROM PURCHASE ORDER

  Future<void> pickImageAndUploadForSupplier(
      BuildContext context,
      ImageSource source,
      WidgetRef ref,
      List<int> ids,
      String suppliedId,
      String logoColor) async {
    final uploadManagerController = ref.read(uploadManagerProvider.notifier);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );
      if (context.mounted && pickedFile != null) {
        context.pop();

        final _croppedFile = await cropImageSettings(
          pickedFile.path,
        );
        if (_croppedFile != null) {
          _uploadImage(ids, _croppedFile.path, uploadManagerController, false,
              logoColor);
          ref.invalidate(dashboardControllerProvider);
          ref.read(officeNavigationController.notifier).state = 0;

          context.go(route);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

// UPLOAD AGAIN FUNCTION FOR UPLOAD FAILED

  Future<void> uploadFailedImageAgain(Map<String, dynamic> arg) async {
    try {
      List<int> ids = arg['ids'];
      String path = arg['path'];
      int dbId = arg['id'];
      WidgetRef ref = arg['ref'];
      String logoColor = arg['logoColor'];
      ref.read(uploadManagerProvider.notifier).changeToLoadingTrue(dbId);

      final response =
          await UploadImageFromProductRepo.onUploadImage(ids, path, logoColor);
      if (response['error'] == false) {
        state = AsyncData(response);
        log(response['data'].toString());
        ref.read(uploadManagerProvider.notifier).deleteWithId(dbId);
      } else {
        state = AsyncError(response['data'].toString(), StackTrace.empty);
        log(response['data'].toString());
        ref.read(uploadManagerProvider.notifier).updateFullModel(
            UploadPhotoModel(
                logoColor: logoColor,
                failedReason: response['data'].toString(),
                ids: ids,
                id: dbId,
                imagePath: path,
                isUploadSuccess: false,
                isUploading: false));
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }
}

final uploadImageControllerProvider =
    AsyncNotifierProvider<UploadImageNotifier, Map<String, dynamic>>(() {
  return UploadImageNotifier();
});

final logoColorSelctionControllerProvider = StateProvider<String>(
  (ref) => 'default',
);
