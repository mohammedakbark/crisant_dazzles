import 'dart:developer';
import 'dart:io';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/core/services/office_navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';
import 'package:dazzles/module/office/pending/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/module/office/pending/data/repo/upload_image_repo.dart';
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

// IMAGE PICKER WITH SINGLE IMAGE UPLOAD FUNCTION
  Future<void> pickImageAndUpload(BuildContext context, ImageSource source,
      ProductModel productModel, WidgetRef ref) async {
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
          _uploadImage(
            [productModel.id],
            _croppedFile.path,
            uploadManagerController,
          );
          ref.read(officeNavigationController.notifier).state = 0;
          context.go(route);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

// SINGLE IMAGE UPLOAD (FROM PENDING IMAGE AND ALL PRODUCTS)

  Future<void> _uploadImage(
    List<int> ids,
    String path,
    UploadManager uploadManagerController,
  ) async {
    showCustomSnackBarAdptive("Uploading...");
    final response = await UploadImageRepo.onUploadImage(ids, path);
    log(response['data']);
    if (response['error'] == false) {
      showCustomSnackBarAdptive("Uploaded successful", isError: false);
    } else {
      showCustomSnackBarAdptive("Uploading failed!", isError: true);
      // state = AsyncError(response['data'].toString(), StackTrace.empty);
      uploadManagerController.addToUplods(UploadPhotoModel(
        failedReason: response['data'].toString(),
        ids: ids,
        imagePath: path,
        isUploadSuccess: false,
      ));
    }
  }

// UPLOAD AGAIN FUNCTION FOR UPLOAD FAILED

  Future<void> uploadFailedImageAgain(Map<String, dynamic> arg) async {
    try {
      List<int> ids = arg['ids'];
      String path = arg['path'];
      int dbId = arg['id'];
      WidgetRef ref = arg['ref'];
      ref.read(uploadManagerProvider.notifier).changeToLoadingTrue(dbId);

      final response = await UploadImageRepo.onUploadImage(ids, path);
      if (response['error'] == false) {
        state = AsyncData(response);
        log(response['data'].toString());
        ref.read(uploadManagerProvider.notifier).deleteWithId(dbId);
      } else {
        state = AsyncError(response['data'].toString(), StackTrace.empty);
        log(response['data'].toString());
        ref.read(uploadManagerProvider.notifier).updateFullModel(
            UploadPhotoModel(
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

//  uploading  multiple ids
  Future<void> uploadMultipleIds(
      BuildContext context, WidgetRef ref, File image) async {
    state = AsyncLoading();
    final idsState = ref.read(selectAndSearchProductControllerProvider);
    final uploadManagerController = ref.read(uploadManagerProvider.notifier);
    List<int> ids = [];
    for (var i in idsState.selectedIds) {
      ids.add(i.id);
    }
    _uploadImage(ids, image.path, uploadManagerController);
    ref.read(officeNavigationController.notifier).state = 0;
    context.go(route);
  }
  // }Future<void> uploadMultipleIds(
  //     BuildContext context, WidgetRef ref, File image) async {
  //   state = AsyncLoading();
  //   final idsState = ref.read(selectAndSearchProductControllerProvider);
  //   final uploadManagerController = ref.read(uploadManagerProvider.notifier);
  //   List<int> ids = [];
  //   for (var i in idsState.selectedIds) {
  //     ids.add(i.id);
  //   }
  //   context.go(route);
  //   final result = await compute(computeImageFiles, {
  //     "image": image,
  //   });

  //   final path = result['path'] as String;
  //   log(path);
  //   final response = await UploadImageRepo.onUploadImage(ids, path);
  //   if (response['error'] == false) {
  //     state = AsyncData(response);

  //     log(response['data'].toString());
  //   } else {
  //     state = AsyncError(response['data'].toString(), StackTrace.empty);
  //     log(response['data'].toString());
  //     uploadManagerController.addToUplods(UploadPhotoModel(
  //       failedReason: response['data'].toString(),
  //       ids: ids,
  //       imagePath: path,
  //       isUploadSuccess: false,
  //     ));
  //   }
  // }

  // if uplaod failed it can trigger from notification

  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }
}

final uploadImageControllerProvider =
    AsyncNotifierProvider<UploadImageNotifier, Map<String, dynamic>>(() {
  return UploadImageNotifier();
});



// Future<File> resizeImageTo2MP(File imageFile) async {
//   // Read image bytes
//   final bytes = await imageFile.readAsBytes();
//   final image = img.decodeImage(bytes);
//   if (image == null) throw Exception("Failed to decode image");

//   // Calculate scale factor to reach ~2MP
//   final currentPixels = image.width * image.height;
//   final targetPixels = 2000000; // 2MP
//   final scaleFactor = (targetPixels / currentPixels).sqrt();

//   final newWidth = (image.width * scaleFactor).round();
//   final newHeight = (image.height * scaleFactor).round();

//   // Resize the image
//   final resized = img.copyResize(image, width: newWidth, height: newHeight);

//   // Get temporary directory to save the resized image
//   final tempDir = await getTemporaryDirectory();
//   final resizedPath = '${tempDir.path}/resized_image.jpg';

//   // Encode and save the resized image
//   final resizedFile = File(resizedPath);
//   await resizedFile.writeAsBytes(img.encodeJpg(resized));

//   return resizedFile;
// }


// Future<Map<String, dynamic>> computeImageFiles(Map<String, dynamic> arg) async {
//   try {
//     // final imageBytes = arg['image'] as List<int>;

//     // final imageData =
//     //     img.decodeImage(Uint8List.fromList(Uint8List.fromList(imageBytes)));
//     // if (imageData == null) {
//     //   log("Failed to decode image");
//     //   return {};
//     // }
//     // final resizedImageData = img.copyResize(imageData, width: 1024);
//     // final jpgBytes = img.encodeJpg(resizedImageData, quality: 85);

//     // final tempDir = Directory.systemTemp;

//     // final filePath =
//     //     '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
//     // final resizedFile = await File(filePath).writeAsBytes(jpgBytes);

//     return {
//       "path": '',
//     };
//   } catch (e) {
//     debugPrint(e.toString());
//     debugPrint("3");
//     return {};
//   }
// }
