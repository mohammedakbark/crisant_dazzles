import 'package:dazzles/features/home/data/models/recently_captured.dart';

class DashboardModel {
  int totalProduct;
  int imagePending;
  int upcomingProducts;
  int supplierReturn;
  List<RecentCapturedModel> recentCaptured;

  DashboardModel({
    required this.totalProduct,
    required this.imagePending,
    required this.upcomingProducts,
    required this.supplierReturn,
    required this.recentCaptured,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    totalProduct: json["totalProduct"] ?? 0,
    imagePending: json["imagePending"] ?? 0,
    upcomingProducts: json["upcomingProducts"] ?? 0,
    supplierReturn: json["supplierReturn"] ?? 0,
    recentCaptured: List<RecentCapturedModel>.from(
      json["recentCaptured"].map((x) => RecentCapturedModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "totalProduct": totalProduct,
    "imagePending": imagePending,
    "upcomingProducts": upcomingProducts,
    "supplierReturn": supplierReturn,
    "recentCaptured": List<dynamic>.from(recentCaptured.map((x) => x.toJson())),
  };
}
