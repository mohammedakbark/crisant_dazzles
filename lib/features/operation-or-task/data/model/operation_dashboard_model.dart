class OperationDashboardModel {
    final int completedCount;
    final int pendingCount;

    OperationDashboardModel({
        required this.completedCount,
        required this.pendingCount,
    });

    factory OperationDashboardModel.fromJson(Map<String, dynamic> json) => OperationDashboardModel(
        completedCount: json["completedCount"],
        pendingCount: json["pendingCount"],
    );

    Map<String, dynamic> toJson() => {
        "completedCount": completedCount,
        "pendingCount": pendingCount,
    };
}