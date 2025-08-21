class PoProductModel {
    int purchaseOrderProductId;
    String productName;
    String category;
    String hsn;
    String size;
    String color;
    int quantity;
    String unitPrice;
    String totalPrice;
    String productHash;
    int productId;
    String productPicture;

    PoProductModel({
        required this.purchaseOrderProductId,
        required this.productName,
        required this.category,
        required this.hsn,
        required this.size,
        required this.color,
        required this.quantity,
        required this.unitPrice,
        required this.totalPrice,
        required this.productHash,
        required this.productId,
        required this.productPicture,
    });

    factory PoProductModel.fromJson(Map<String, dynamic> json) => PoProductModel(
        purchaseOrderProductId: json["purchaseOrderProductId"],
        productName: json["productName"],
        category: json["category"],
        hsn: json["hsn"],
        size: json["size"],
        color: json["color"],
        quantity: json["quantity"],
        unitPrice: json["unitPrice"],
        totalPrice: json["totalPrice"],
        productHash: json["productHash"],
        productId: json["productId"]??'',
        productPicture: json["productPicture"]??'',
    );

    Map<String, dynamic> toJson() => {
        "purchaseOrderProductId": purchaseOrderProductId,
        "productName": productName,
        "category": category,
        "hsn": hsn,
        "size": size,
        "color": color,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "totalPrice": totalPrice,
        "productHash": productHash,
        "productId": productId,
        "productPicture": productPicture,
    };
}