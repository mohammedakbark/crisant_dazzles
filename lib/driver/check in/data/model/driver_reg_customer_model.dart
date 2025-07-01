class DriverRegCustomerModel {
  final int id;
  final String number;
  final String name;
  final String displayText;

  DriverRegCustomerModel({
    required this.id,
    required this.number,
    required this.name,
    required this.displayText,
  });

  factory DriverRegCustomerModel.fromJson(Map<String, dynamic> json) => DriverRegCustomerModel(
        id: json["id"] ?? '',
        number: json["number"] ?? '',
        name: json["name"] ?? '',
        displayText: json["displayText"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "name": name,
        "displayText": displayText,
      };
}
