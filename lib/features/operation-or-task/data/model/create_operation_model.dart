import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';

class CreateOperationModel {
  final String operationName;
  final ScheduleType scheduleType;
  final String? specialDate;
  final SubmissionMode submissionType;
  final int galleryAccess;
  final String startTime;
  final String endTime;

  CreateOperationModel({
    required this.operationName,
    required this.scheduleType,
    required this.specialDate,
    required this.submissionType,
    required this.galleryAccess,
    required this.startTime,
    required this.endTime,
  });

  factory CreateOperationModel.fromJson(Map<String, dynamic> json) =>
      CreateOperationModel(
        operationName: json["operationName"],
        scheduleType: json["scheduleType"],
        specialDate: json["specialDate"],
        submissionType: parseSubmissionMode(json["submissionType"]),
        galleryAccess: json["galleryAccess"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "operationName": operationName,
        "scheduleType": scheduleTypeToString(scheduleType),
        "specialDate": specialDate,
        "submissionType": submissionModeToString(submissionType),
        "galleryAccess": galleryAccess,
        "startTime": startTime,
        "endTime": endTime,
      };
}
