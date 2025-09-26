enum SubmissionMode { text, image, video }

SubmissionMode parseSubmissionMode(String mode) {
  switch (mode.toLowerCase()) {
    case 'text':
      return SubmissionMode.text;
    case 'image':
      return SubmissionMode.image;
    case 'video':
      return SubmissionMode.video;
    default:
      return SubmissionMode.text;
  }
}

String submissionModeToString(SubmissionMode mode) {
  return mode.name.toString();
}

enum ScheduleType { once, daily }

ScheduleType parseScheduleType(String type) {
  switch (type.toLowerCase()) {
    case 'once':
      return ScheduleType.once;
    case 'daily':
      return ScheduleType.daily;
    default:
      return ScheduleType.daily;
  }
}

String scheduleTypeToString(ScheduleType type) {
  return type.name.toString();
}

enum OperationStatus { assigned, completed, expired }
