class EmployeeModelForOperation {
  final int employeeId;
  final String fullName;
  final String mobileNumber;
  final int reportTo;
  final dynamic otp;
  final dynamic pushToken;
  final int roleId;
  final int storeId;
  final String status;
  final dynamic skillLevel;
  final dynamic gradeLevel;
  final DateTime createdAt;
  final DateTime modifiedAt;

  EmployeeModelForOperation({
    required this.employeeId,
    required this.fullName,
    required this.mobileNumber,
    required this.reportTo,
    required this.otp,
    required this.pushToken,
    required this.roleId,
    required this.storeId,
    required this.status,
    required this.skillLevel,
    required this.gradeLevel,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory EmployeeModelForOperation.fromJson(Map<String, dynamic> json) =>
      EmployeeModelForOperation(
        employeeId: json["employeeId"],
        fullName: json["fullName"],
        mobileNumber: json["mobileNumber"],
        reportTo: json["reportTo"],
        otp: json["otp"],
        pushToken: json["pushToken"],
        roleId: json["roleId"],
        storeId: json["storeId"],
        status: json["status"],
        skillLevel: json["skillLevel"],
        gradeLevel: json["gradeLevel"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "reportTo": reportTo,
        "otp": otp,
        "pushToken": pushToken,
        "roleId": roleId,
        "storeId": storeId,
        "status": status,
        "skillLevel": skillLevel,
        "gradeLevel": gradeLevel,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
      };
}
