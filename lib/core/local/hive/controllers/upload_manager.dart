import 'dart:async';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class UploadManager extends AsyncNotifier<List<UploadPhotoModel>> {
  static const db = "uploads";

  clearAll() async {
    state = AsyncLoading();
    final box = Hive.box<UploadPhotoModel>(db);
    await box.clear();
    await build();
  }

  @override
  FutureOr<List<UploadPhotoModel>> build() async {
    state = AsyncLoading();
    return await fetchUplaods();
  }

  Future<List<UploadPhotoModel>> fetchUplaods() async {
    final box = Hive.box<UploadPhotoModel>(db);
    state = AsyncData(box.values.toList());
    return await box.values.toList();
  }

//---------------------------------
  Future<void> addToUplods(UploadPhotoModel upload) async {
    final box = Hive.box<UploadPhotoModel>(db);
    upload.dateTime = DateTime.now();
    final key = await box.add(upload);
    upload.id = key;
    await box.put(key, upload);
    fetchUplaods();
  }

  Future<void> changeToLoadingTrue(int id) async {
    final box = Hive.box<UploadPhotoModel>(db);
    final model = await _getUploadData(id);
    if (model != null) {
      model.isUploading = true;
      box.put(id, model);
      state = AsyncData(box.values.toList());
    }
  }

  Future<UploadPhotoModel?> _getUploadData(int id) async {
    final box = Hive.box<UploadPhotoModel>(db);
    return await box.get(id);
  }

  Future<void> deleteWithId(int id) async {
    final box = Hive.box<UploadPhotoModel>(db);
    box.delete(id);
    state = AsyncData(box.values.toList());
  }

  Future<void> updateFullModel(UploadPhotoModel model) async {
    final box = Hive.box<UploadPhotoModel>(db);
    box.put(model.id, model);
    state = AsyncData(box.values.toList());
  }
}

final uploadManagerProvider =
    AsyncNotifierProvider<UploadManager, List<UploadPhotoModel>>(
        () => UploadManager());
