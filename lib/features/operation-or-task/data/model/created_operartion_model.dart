import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';

class CreatedOperationModel {
  final int operationId;
  final String operationName;
  final dynamic specialDate;
  final ScheduleType scheduleType;
  final SubmissionMode submissionType;
  final int galleryAccess;
  final int createdBy;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final DateTime modifiedAt;
  // final List<AssignedEmployees> assignedTo;

  CreatedOperationModel({
    required this.operationId,
    required this.operationName,
    required this.specialDate,
    required this.scheduleType,
    required this.submissionType,
    required this.galleryAccess,
    required this.createdBy,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory CreatedOperationModel.fromJson(Map<String, dynamic> json) =>
      CreatedOperationModel(
        // assignedTo: json['assignedTo'] ?? [],
        operationId: json["operationId"],
        operationName: json["operationName"],
        specialDate: json["specialDate"],
        scheduleType: parseScheduleType(json["scheduleType"]),
        submissionType: parseSubmissionMode(json["submissionType"]),
        galleryAccess: json["galleryAccess"],
        createdBy: json["createdBy"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        // "assignedTo": assignedTo,
        "operationId": operationId,
        "operationName": operationName,
        "specialDate": specialDate,
        "scheduleType": scheduleTypeToString(scheduleType),
        "submissionType": submissionModeToString(submissionType),
        "galleryAccess": galleryAccess,
        "createdBy": createdBy,
        "startTime": startTime,
        "endTime": endTime,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
      };
}
