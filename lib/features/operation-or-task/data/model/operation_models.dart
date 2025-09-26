// lib/features/operation/models/operation_models.dart
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';

class Employee {
  final int id;
  final String name;
  final String role;
  Employee({required this.id, required this.name, required this.role});
}

class OperationTask {
  final String id;
  final String name;
  final DateTime fromTime;
  final DateTime toTime;
  final SubmissionMode submissionMode;
  final bool allowGallery;
  final ScheduleType recurrenceMode;
  final DateTime? specificDate; // used when recurrenceMode == specificDate
  OperationStatus status;
  int assigneeId; // employee id
  DateTime createdAt;

  OperationTask({
    required this.id,
    required this.name,
    required this.fromTime,
    required this.toTime,
    required this.submissionMode,
    required this.allowGallery,
    required this.recurrenceMode,
    this.specificDate,
    this.status = OperationStatus.assigned,
    required this.assigneeId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  OperationTask copyWith({
    String? id,
    String? name,
    DateTime? fromTime,
    DateTime? toTime,
    SubmissionMode? submissionMode,
    bool? allowGallery,
    ScheduleType? recurrenceMode,
    DateTime? specificDate,
    OperationStatus? status,
    int? assigneeId,
    DateTime? createdAt,
  }) {
    return OperationTask(
      id: id ?? this.id,
      name: name ?? this.name,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      submissionMode: submissionMode ?? this.submissionMode,
      allowGallery: allowGallery ?? this.allowGallery,
      recurrenceMode: recurrenceMode ?? this.recurrenceMode,
      specificDate: specificDate ?? this.specificDate,
      status: status ?? this.status,
      assigneeId: assigneeId ?? this.assigneeId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
