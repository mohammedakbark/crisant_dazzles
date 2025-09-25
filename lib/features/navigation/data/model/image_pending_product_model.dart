class ImagePendingProductsModel {
  final int? id;
  final String productName;
  final String supplierName;
  final String productPicture;
  final String category;
  final String productSize;
  final String color;

  ImagePendingProductsModel({
    required this.id,
    required this.productName,
    required this.supplierName,
    required this.productPicture,
    required this.category,
    required this.productSize,
    required this.color,
  });

  factory ImagePendingProductsModel.fromJson(Map<String, dynamic> json) =>
      ImagePendingProductsModel(
        id: json["id"],
        productName: json["productName"] ?? '',
        supplierName: json["supplierName"] ?? '',
        productPicture: json["productPicture"] ?? '',
        category: json["category"] ?? '',
        productSize: json["productSize"] ?? '',
        color: json["color"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "supplierName": supplierName,
        "productPicture": productPicture,
        "category": category,
        "productSize": productSize,
        "color": color,
      };
}
