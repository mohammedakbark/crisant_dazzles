class NotificationModel {
    final int notificationId;
    final String notification;
    final String ?notificationImage;
    final int isRead;
    final DateTime createdAt;

    NotificationModel({
        required this.notificationId,
        required this.notification,
        required this.notificationImage,
        required this.isRead,
        required this.createdAt,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        notificationId: json["notificationId"]??'',
        notification: json["notification"]??'',
        notificationImage: json["notificationImage"],
        isRead: json["isRead"]??3,
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "notification": notification,
        "notificationImage": notificationImage,
        "isRead": isRead,
        "created_at": createdAt.toIso8601String(),
    };
}