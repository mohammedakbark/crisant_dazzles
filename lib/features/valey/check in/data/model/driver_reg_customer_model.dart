class DriverCustomerSuggessionModel {
  final int id;
  final String number;
  final String name;
  final String displayText;

  DriverCustomerSuggessionModel({
    required this.id,
    required this.number,
    required this.name,
    required this.displayText,
  });

  factory DriverCustomerSuggessionModel.fromJson(Map<String, dynamic> json) => DriverCustomerSuggessionModel(
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
