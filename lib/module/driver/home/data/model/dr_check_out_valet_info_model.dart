class DrCheckOutValetInfoModel {
    final int valetId;
    final String customerName;
    final String mobileNumber;
    final String vehicleNumber;
    final String brand;
    final String model;
    final double long;
    final double latt;

    DrCheckOutValetInfoModel({
        required this.valetId,
        required this.customerName,
        required this.mobileNumber,
        required this.vehicleNumber,
        required this.brand,
        required this.model,
        required this.long,
        required this.latt,
    });

    factory DrCheckOutValetInfoModel.fromJson(Map<String, dynamic> json) => DrCheckOutValetInfoModel(
        valetId: json["valetId"],
        customerName: json["customerName"],
        mobileNumber: json["mobileNumber"],
        vehicleNumber: json["vehicleNumber"],
        brand: json["brand"],
        model: json["model"],
        long: json["long"]?.toDouble(),
        latt: json["latt"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "valetId": valetId,
        "customerName": customerName,
        "mobileNumber": mobileNumber,
        "vehicleNumber": vehicleNumber,
        "brand": brand,
        "model": model,
        "long": long,
        "latt": latt,
    };
}