import 'package:dazzles/features/product/data/models/product_vailable_quantity_model.dart';

class ScannedProductModel {
  final int id;
  final String productName;
  final String salesprice;
  final String purchaseprice;
  final String productPicture;
  final String category;
  final String productSize;
  final String color;
  final String supplier;
  final List<ProductavailableQuantity> quantity;
  final List<Attribute> attributes;
  final List<SimilarProduct> similarProducts;

  ScannedProductModel({
    required this.id,
    required this.productName,
    required this.salesprice,
    required this.purchaseprice,
    required this.productPicture,
    required this.category,
    required this.productSize,
    required this.color,
    required this.supplier,
    required this.quantity,
    required this.attributes,
    required this.similarProducts,
  });

  factory ScannedProductModel.fromJson(Map<String, dynamic> json) =>
      ScannedProductModel(
        id: json["id"] ?? '',
        productName: json["productName"] ?? '',
        salesprice: json["salesprice"] ?? '',
        purchaseprice: json["purchaseprice"] ?? '',
        productPicture: json["productPicture"] ?? '',
        category: json["category"] ?? '',
        productSize: json["productSize"] ?? '',
        color: json["color"] ?? '',
        supplier: json["supplier"] ?? '',
        quantity: List<ProductavailableQuantity>.from(
            json["quantity"].map((x) => ProductavailableQuantity.fromJson(x))),
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
        similarProducts: List<SimilarProduct>.from(
            json["similarProducts"].map((x) => SimilarProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "salesprice": salesprice,
        "purchaseprice": purchaseprice,
        "productPicture": productPicture,
        "category": category,
        "productSize": productSize,
        "color": color,
        "supplier": supplier,
        "quantity": List<dynamic>.from(quantity.map((x) => x.toJson())),
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
        "similarProducts":
            List<dynamic>.from(similarProducts.map((x) => x.toJson())),
      };
}

class Attribute {
  final String name;
  final String value;

  Attribute({
    required this.name,
    required this.value,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: json["name"] ?? '',
        value: json["value"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}



class SimilarProduct {
  final int id;
  final String productPicture;
  final String size;
  final String color;
  // final List<SimilarProductQuantity> quantity;

  SimilarProduct({
    required this.id,
    required this.productPicture,
    required this.size,
    required this.color,
    // required this.quantity,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) => SimilarProduct(
        id: json["id"],
        productPicture: json["productPicture"],
        size: json["size"],
        color: json["color"],
        // quantity: List<SimilarProductQuantity>.from(
        //     json["quantity"].map((x) => SimilarProductQuantity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productPicture": productPicture,
        "size": size,
        "color": color,
        // "quantity": List<dynamic>.from(quantity.map((x) => x.toJson())),
      };
}
