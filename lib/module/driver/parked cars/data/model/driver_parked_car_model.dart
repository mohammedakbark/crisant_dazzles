class DriverParkedCarModel {
    final int valetId;
    final String storeName;
    final int qrNumber;
    final String vehicleNumber;
    final String vehicleBrand;
    final String vehicleModel;
    final String customerName;
    final String parkedby;
    final int? deliveredBy;
    final String customerNumber;
    final double? longitude;
    final double? latitude;
    final String? initialVideo;
    final String? finalVideo;
    final int parkedBy;
    final DateTime parkedAt;
    final DateTime deliveredAt;
    final String parkingTime;
    final String status;

    DriverParkedCarModel({
        required this.valetId,
        required this.storeName,
        required this.qrNumber,
        required this.vehicleNumber,
        required this.vehicleBrand,
        required this.vehicleModel,
        required this.customerName,
        required this.parkedby,
        required this.deliveredBy,
        required this.customerNumber,
        required this.longitude,
        required this.latitude,
        required this.initialVideo,
        required this.finalVideo,
        required this.parkedBy,
        required this.parkedAt,
        required this.deliveredAt,
        required this.status,
        required this.parkingTime
    });

    factory DriverParkedCarModel.fromJson(Map<String, dynamic> json) => DriverParkedCarModel(
      parkingTime: json["parkingTime"],
        valetId: json["valetId"],
        storeName: json["storeName"],
        qrNumber: json["qrNumber"],
        vehicleNumber: json["vehicleNumber"],
        vehicleBrand: json["vehicleBrand"],
        vehicleModel: json["vehicleModel"],
        customerName: json["customerName"],
        parkedby: json["parkedby"],
        deliveredBy: json["deliveredBy"],
        customerNumber: json["customerNumber"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        initialVideo: json["initialVideo"],
        finalVideo: json["finalVideo"],
        parkedBy: json["parkedBy"],
        parkedAt: DateTime.parse(json["parkedAt"]),
        deliveredAt: DateTime.parse(json["deliveredAt"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
      "parkingTime":parkingTime,
        "valetId": valetId,
        "storeName": storeName,
        "qrNumber": qrNumber,
        "vehicleNumber": vehicleNumber,
        "vehicleBrand": vehicleBrand,
        "vehicleModel": vehicleModel,
        "customerName": customerName,
        "parkedby": parkedby,
        "deliveredBy": deliveredBy,
        "customerNumber": customerNumber,
        "longitude": longitude,
        "latitude": latitude,
        "initialVideo": initialVideo,
        "finalVideo": finalVideo,
        "parkedBy": parkedBy,
        "parkedAt": parkedAt.toIso8601String(),
        "deliveredAt": deliveredAt.toIso8601String(),
        "status": status,
    };
}
