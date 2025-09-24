class ProductavailableQuantity {
  final int storeId;
  final String storeShortName;
  final dynamic quantity;
  final dynamic sales;

  ProductavailableQuantity({
    required this.storeId,
    required this.storeShortName,
    required this.quantity,
    required this.sales,
  });

  factory ProductavailableQuantity.fromJson(Map<String, dynamic> json) =>
      ProductavailableQuantity(
        storeId: json["storeId"],
        storeShortName: json["storeShortName"] ?? '',
        quantity: json["quantity"] ?? '',
        sales: json["sales"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "storeShortName": storeShortName,
        "quantity": quantity,
        "sales": sales,
      };
}
