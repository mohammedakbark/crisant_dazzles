class ProductModel {
  int id;
  String productName;
  String? productPicture;
  String category;
  String productSize;
  String color;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPicture,
    required this.category,
    required this.productSize,
    required this.color,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    productName: json["productName"] ?? '',
    productPicture: json["productPicture"],
    category: json["category"] ?? '',
    productSize: json["productSize"] ?? '',
    color: json["color"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "productPicture": productPicture,
    "category": category,
    "productSize": productSize,
    "color": color,
  };
}
