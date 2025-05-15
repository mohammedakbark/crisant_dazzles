import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/providers/get%20pending%20products/get_pending_products_controller.dart';
import 'package:dazzles/features/upload/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/features/upload/data/repo/upload_image_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class UploadImageNotifier extends AsyncNotifier<Map<String, dynamic>> {
  static Future<void> pickImage(
    BuildContext context,
    ImageSource source,
    ProductModel productModel,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (context.mounted && pickedFile != null) {
        context.pop();
        context.push(
          imagePreview,
          extra: {"productModel": productModel, "path": pickedFile.path},
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

//  uploading
  Future<void> uploadFunction(
      BuildContext context, WidgetRef ref, List<int> image) async {
    state = AsyncLoading();
    final idsState = ref.read(selectAndSearchProductControllerProvider);
    final uploadManagerController = ref.read(uploadManagerProvider.notifier);
    List<int> ids = [];
    for (var i in idsState.selectedIds) {
      ids.add(i.id);
    }
    context.go(route);
    final result = await compute(computeImageFiles, {
      "image": image,
    });

    final path = result['path'] as String;
    log(path);
    final response = await UploadImageRepo.onUploadImage(ids, path);
    if (response['error'] == false) {
      state = AsyncData(response);

      log(response['data'].toString());
    } else {
      state = AsyncError(response['data'].toString(), StackTrace.empty);
      log(response['data'].toString());
      uploadManagerController.addToUplods(UploadPhotoModel(
        failedReason: response['data'].toString(),
        ids: ids,
        imagePath: path,
        isUploadSuccess: false,
      ));
    }
  }

  // if uplaod failed it can trigger from notification
  Future<void> uploadFailedImageAgain(Map<String, dynamic> arg) async {
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
      ref.read(uploadManagerProvider.notifier).updateFullModel(UploadPhotoModel(
          failedReason: response['data'].toString(),
          ids: ids,
          id: dbId,
          imagePath: path,
          isUploadSuccess: false,
          isUploading: false));
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

Future<Map<String, dynamic>> computeImageFiles(Map<String, dynamic> arg) async {
  try {
    final imageBytes = arg['image'] as List<int>;

    final imageData =
        img.decodeImage(Uint8List.fromList(Uint8List.fromList(imageBytes)));
    if (imageData == null) {
      log("Failed to decode image");
      return {};
    }
    final resizedImageData = img.copyResize(imageData, width: 1024);
    final jpgBytes = img.encodeJpg(resizedImageData, quality: 85);

    final tempDir = Directory.systemTemp;

    final filePath =
        '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
    final resizedFile = await File(filePath).writeAsBytes(jpgBytes);

    return {
      "path": resizedFile.path,
    };
  } catch (e) {
    debugPrint(e.toString());
    debugPrint("3");
    return {};
  }
}
