class DriverCustomerCarSuggessionModel {
    final int id;
    final String vehicleNumber;
    final String model;
    final String brand;
    final String displayText;

    DriverCustomerCarSuggessionModel({
        required this.id,
        required this.vehicleNumber,
        required this.model,
        required this.brand,
        required this.displayText,
    });

    factory DriverCustomerCarSuggessionModel.fromJson(Map<String, dynamic> json) => DriverCustomerCarSuggessionModel(
        id: json["id"],
        vehicleNumber: json["vehicleNumber"],
        model: json["model"],
        brand: json["brand"],
        displayText: json["displayText"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleNumber": vehicleNumber,
        "model": model,
        "brand": brand,
        "displayText": displayText,
    };
}