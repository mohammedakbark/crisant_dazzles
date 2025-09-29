class AssignedEmployeeStatusModel {
  final int employeeId;
  final String employeeName;
  final int operationId;
  final String operationName;
  final String scheduleType;
  final String assignedId;
  final String status;

  AssignedEmployeeStatusModel(
      {required this.employeeId,
      required this.employeeName,
      required this.operationId,
      required this.operationName,
      required this.scheduleType,
      required this.status,
      required this.assignedId});

  factory AssignedEmployeeStatusModel.fromJson(Map<String, dynamic> json) =>
      AssignedEmployeeStatusModel(
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        operationId: json["operationId"],
        operationName: json["operationName"],
        assignedId: json['assignedId'].toString(),
        scheduleType: json["scheduleType"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "employeeName": employeeName,
        "operationId": operationId,
        "operationName": operationName,
        "scheduleType": scheduleType,
        "status": status,
        "assignedId": assignedId
      };
}
