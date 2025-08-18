// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UploadPhotoModelAdapter extends TypeAdapter<UploadPhotoModel> {
  @override
  final int typeId = 0;

  @override
  UploadPhotoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UploadPhotoModel(
      ids: (fields[2] as List).cast<int>(),
      id: fields[0] as int?,
      isUploading: fields[6] as bool?,
      imagePath: fields[1] as String,
      isUploadSuccess: fields[3] as bool,
      failedReason: fields[5] as String,
      logoColor: fields[7] as String,
      dateTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UploadPhotoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.ids)
      ..writeByte(3)
      ..write(obj.isUploadSuccess)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.failedReason)
      ..writeByte(6)
      ..write(obj.isUploading)
      ..writeByte(7)
      ..write(obj.logoColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadPhotoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
