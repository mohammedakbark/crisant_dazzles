import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';

class ToDoOperationModel {
  final int assignedId;
  final String? assignedBy;
  final int? operationId;
  final String? operationName;
  final ScheduleType? scheduleType;
  final SubmissionMode? submissionType;
  final int? galleryAccess;
  final dynamic specialDate;
  final String? startTime;
  final String? endTime;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  ToDoOperationModel({
    required this.assignedId,
    required this.assignedBy,
    required this.operationId,
    required this.operationName,
    required this.scheduleType,
    required this.submissionType,
    required this.galleryAccess,
    required this.specialDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory ToDoOperationModel.fromJson(Map<String, dynamic> json) =>
      ToDoOperationModel(
        assignedId: json["assignedId"],
        assignedBy: json["assignedBy"] ?? '',
        operationId: json["operationId"] ?? 0,
        operationName: json["operationName"] ?? '',
        scheduleType: parseScheduleType(json["scheduleType"] ?? "once"),
        submissionType: parseSubmissionMode(json["submissionType"] ?? 'text'),
        galleryAccess: json["galleryAccess"] ?? 0,
        specialDate: json["specialDate"] ?? '',
        startTime: json["startTime"] ?? '',
        endTime: json["endTime"] ?? '',
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        modifiedAt:json["modifiedAt"]==null?null: DateTime.parse(json["modifiedAt"]),
      );
  // Map<String, dynamic> toJson() => {
  //       "assignedId": assignedId,
  //       "assignedBy": assignedBy,
  //       "operationId": operationId,
  //       "operationName": operationName,
  //       "scheduleType": scheduleTypeToString(scheduleType),
  //       "submissionType": submissionModeToString(submissionType),
  //       "galleryAccess": galleryAccess,
  //       "specialDate": specialDate,
  //       "startTime": startTime,
  //       "endTime": endTime,
  //       "createdAt": createdAt.toIso8601String(),
  //       "modifiedAt": modifiedAt.toIso8601String(),
  //     };
}
