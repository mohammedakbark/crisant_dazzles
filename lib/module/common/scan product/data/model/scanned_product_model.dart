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
  final List<Quantity> quantity;
  final List<Attribute> attributes;

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
        quantity: List<Quantity>.from(
            json["quantity"].map((x) => Quantity.fromJson(x))),
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
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

class Quantity {
  final int storeId;
  final String storeName;
  final int quantity;

  Quantity({
    required this.storeId,
    required this.storeName,
    required this.quantity,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        storeId: json["storeId"] ?? "",
        storeName: json["storeName"] ?? "",
        quantity: json["quantity"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "storeName": storeName,
        "quantity": quantity,
      };
}
