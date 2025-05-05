class ProductDataModel {
    String productName;
    String productsize;
    String color;
    String productCategory;
    int availableQuantity;
    String productPurchaseRate;
    String productSellingPrice;
    String supplier;
    String productDescription;
    String productPicture;

    ProductDataModel({
        required this.productName,
        required this.productsize,
        required this.color,
        required this.productCategory,
        required this.availableQuantity,
        required this.productPurchaseRate,
        required this.productSellingPrice,
        required this.supplier,
        required this.productDescription,
        required this.productPicture,
    });

    factory ProductDataModel.fromJson(Map<String, dynamic> json) => ProductDataModel(
        productName: json["productName"],
        productsize: json["productsize"],
        color: json["color"],
        productCategory: json["productCategory"],
        availableQuantity: json["availableQuantity"],
        productPurchaseRate: json["productPurchaseRate"],
        productSellingPrice: json["productSellingPrice"],
        supplier: json["supplier"],
        productDescription: json["productDescription"],
        productPicture: json["productPicture"],
    );

    Map<String, dynamic> toJson() => {
        "productName": productName,
        "productsize": productsize,
        "color": color,
        "productCategory": productCategory,
        "availableQuantity": availableQuantity,
        "productPurchaseRate": productPurchaseRate,
        "productSellingPrice": productSellingPrice,
        "supplier": supplier,
        "productDescription": productDescription,
        "productPicture": productPicture,
    };
}