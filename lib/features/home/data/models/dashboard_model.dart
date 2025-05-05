import 'package:dazzles/features/home/data/models/recently_captured.dart';

class DashboardModel {
  int totalProduct;
  int imagePending;
  int upcomingProducts;
  int imageRejected;
  List<RecentCapturedModel> recentCaptured;

  DashboardModel({
    required this.totalProduct,
    required this.imagePending,
    required this.upcomingProducts,
    required this.imageRejected,
    required this.recentCaptured,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    totalProduct: json["totalProduct"] ?? '',
    imagePending: json["imagePending"] ?? '',
    upcomingProducts: json["upcomingProducts"] ?? '',
    imageRejected: json["imageRejected"] ?? '',
    recentCaptured: List<RecentCapturedModel>.from(
      json["recentCaptured"].map((x) => RecentCapturedModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "totalProduct": totalProduct,
    "imagePending": imagePending,
    "upcomingProducts": upcomingProducts,
    "imageRejected": imageRejected,
    "recentCaptured": List<dynamic>.from(recentCaptured.map((x) => x.toJson())),
  };
}
