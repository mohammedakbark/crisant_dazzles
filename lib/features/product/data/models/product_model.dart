import 'package:dazzles/features/product/data/models/product_vailable_quantity_model.dart';

class ProductModel {
  final int id;
  final String productName;
  final String productPicture;
  final String category;
  final String productSize;
  final String color;
  final List<ProductavailableQuantity> availableQuantity;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPicture,
    required this.category,
    required this.productSize,
    required this.color,
    required this.availableQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productName: json["productName"] ?? '',
        productPicture: json["productPicture"] ?? '',
        category: json["category"] ?? '',
        productSize: json["productSize"] ?? '',
        color: json["color"] ?? '',
        availableQuantity: List<ProductavailableQuantity>.from(
            json["availableQuantity"]
                .map((x) => ProductavailableQuantity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "productPicture": productPicture,
        "category": category,
        "productSize": productSize,
        "color": color,
        "availableQuantity":
            List<dynamic>.from(availableQuantity.map((x) => x.toJson())),
      };
}
