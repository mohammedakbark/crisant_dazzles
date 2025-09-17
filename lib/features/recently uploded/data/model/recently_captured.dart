class RecentCapturedModel {
  int productId;
  String productName;
  String productPicture;

  RecentCapturedModel({
    required this.productId,
    required this.productName,
    required this.productPicture,
  });

  factory RecentCapturedModel.fromJson(Map<String, dynamic> json) =>
      RecentCapturedModel(
        productId: json["productId"] ?? '',
        productName: json["productName"] ?? '',
        productPicture: json["productPicture"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "productPicture": productPicture,
  };
}
