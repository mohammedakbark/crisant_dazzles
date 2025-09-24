import 'package:dazzles/features/product/data/models/product_vailable_quantity_model.dart';

class ProductDataModel {
  String productName;
  String productsize;
  String color;
  String productCategory;
  String producthsn;
  int availableQuantity;
  String productPurchaseRate;
  String productSellingPrice;
  String supplier;
  String? productDescription;
  String productPicture;
  List<FormattedAttribute> formattedAttributes;
  final List<ProductavailableQuantity> productavailableQuantity;

  ProductDataModel({
    required this.productName,
    required this.productsize,
    required this.color,
    required this.productCategory,
    required this.producthsn,
    required this.availableQuantity,
    required this.productPurchaseRate,
    required this.productSellingPrice,
    required this.supplier,
    required this.productDescription,
    required this.productPicture,
    required this.formattedAttributes,
    required this.productavailableQuantity,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      ProductDataModel(
        productName: json["productName"] ?? '',
        productsize: json["productsize"] ?? '',
        color: json["color"] ?? '',
        productCategory: json["productCategory"] ?? '',
        producthsn: json["producthsn"] ?? '',
        availableQuantity: json["availableQuantity"] ?? 0,
        productPurchaseRate: json["productPurchaseRate"] ?? '',
        productSellingPrice: json["productSellingPrice"] ?? '',
        supplier: json["supplier"] ?? '',
        productDescription: json["productDescription"] == "Null"
            ? null
            : json["productDescription"],
        productPicture: json["productPicture"] ?? '',
        formattedAttributes: List<FormattedAttribute>.from(
            json["formattedAttributes"]
                .map((x) => FormattedAttribute.fromJson(x))),
        productavailableQuantity: List<ProductavailableQuantity>.from(
            json["productavailableQuantity"]
                .map((x) => ProductavailableQuantity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "productsize": productsize,
        "color": color,
        "productCategory": productCategory,
        "producthsn": producthsn,
        "availableQuantity": availableQuantity,
        "productPurchaseRate": productPurchaseRate,
        "productSellingPrice": productSellingPrice,
        "supplier": supplier,
        "productDescription": productDescription,
        "productPicture": productPicture,
        "formattedAttributes":
            List<dynamic>.from(formattedAttributes.map((x) => x.toJson())),
        "productavailableQuantity":
            List<dynamic>.from(productavailableQuantity.map((x) => x.toJson())),
      };
}

class FormattedAttribute {
  int productAttributeId;
  int attributeaid;
  int productId;
  String attributename;
  String attributevalue;

  FormattedAttribute({
    required this.productAttributeId,
    required this.attributeaid,
    required this.productId,
    required this.attributename,
    required this.attributevalue,
  });

  factory FormattedAttribute.fromJson(Map<String, dynamic> json) =>
      FormattedAttribute(
        productAttributeId: json["productAttributeId"] ?? '',
        attributeaid: json["attributeaid"] ?? '',
        productId: json["productId"] ?? '',
        attributename: json["attributename"] ?? '',
        attributevalue: json["attributevalue"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "productAttributeId": productAttributeId,
        "attributeaid": attributeaid,
        "productId": productId,
        "attributename": attributename,
        "attributevalue": attributevalue,
      };
}
