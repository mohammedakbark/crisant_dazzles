import 'dart:developer';
import 'dart:io';

import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/upload/data/repo/upload_image_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UploadImageNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    return {};
  }

  Future<void> uploadImage({
    required BuildContext context,
    required dynamic productId,
    required File file,
  }) async {
    try {
      state = const AsyncLoading();

      final result = await UploadImageRepo.onUploadImage(productId, file);

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
}

final uploadImageControllerProvider =
    AsyncNotifierProvider<UploadImageNotifier, Map<String, dynamic>>(() {
      return UploadImageNotifier();
    });

