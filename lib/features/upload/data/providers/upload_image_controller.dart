import 'dart:developer';
import 'dart:io';

import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/repo/upload_image_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }

  Future<void> uploadImage({
    required BuildContext context,
    required List<int> productIds,
    required File file,
  }) async {
    try {
      state = const AsyncLoading();

      final result = await UploadImageRepo.onUploadImage(productIds, file);

      if (result["error"] == false) {
        state = AsyncData(result);
        showCustomSnackBar(context, content: result["data"]);
      } else {
        log(result["data"]);
        state = AsyncError(result["data"], StackTrace.current);
        showCustomSnackBar(
          context,
          content: result["data"],
          contentType: ContentType.failure,
        );
      }
    } catch (e, t) {
      log(e.toString());
      state = AsyncError(e, t);
      showCustomSnackBar(
        context,
        content: e.toString(),
        contentType: ContentType.failure,
      );
    }
  }

 static Future<void> pickImage(
    BuildContext context,
    ImageSource source,
    ProductModel productModel,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        if (context.mounted) {
          context.pop();
          context.push(
            imagePreview,
            extra: {"productModel": productModel, "path": pickedFile.path},
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

final uploadImageControllerProvider =
    AsyncNotifierProvider<UploadImageNotifier, Map<String, dynamic>>(() {
      return UploadImageNotifier();
    });
