class OperationRequestModel {
    final int operationRequestId;
    final int requestBy;
    final int requestTo;
    final int operationRecordId;
    final int status;
    final String reason;
    final DateTime createdAt;
    final DateTime modifiedAt;

    OperationRequestModel({
        required this.operationRequestId,
        required this.requestBy,
        required this.requestTo,
        required this.operationRecordId,
        required this.status,
        required this.reason,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory OperationRequestModel.fromJson(Map<String, dynamic> json) => OperationRequestModel(
        operationRequestId: json["operationRequestId"],
        requestBy: json["requestBy"],
        requestTo: json["requestTo"],
        operationRecordId: json["operationRecordId"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "operationRequestId": operationRequestId,
        "requestBy": requestBy,
        "requestTo": requestTo,
        "operationRecordId": operationRecordId,
        "status": status,
        "reason": reason,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}