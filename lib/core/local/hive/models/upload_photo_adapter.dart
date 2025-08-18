import 'package:hive/hive.dart';

part 'upload_photo_adapter.g.dart';

@HiveType(typeId: 0)
class UploadPhotoModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  List<int> ids;

  @HiveField(3)
  bool isUploadSuccess;

  @HiveField(4)
  DateTime? dateTime = DateTime.now();

  @HiveField(5)
  String failedReason;

  @HiveField(6)
  bool? isUploading = false;

  @HiveField(7)
  String logoColor;

  UploadPhotoModel(
      {required this.ids,
      this.id,
      this.isUploading,
      required this.imagePath,
      required this.isUploadSuccess,
      required this.failedReason,
      required this.logoColor,
      this.dateTime});
}
