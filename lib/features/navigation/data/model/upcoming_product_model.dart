class UpcomingProductsModel {
  final int id;
  final String invoiceNumber;
  final dynamic storeId;
  final String status;
  final DateTime invoiceDate;
  final String transportName;
  final dynamic receivedDate;
  final String supplierId;
  final String supplierName;

  UpcomingProductsModel({
    required this.id,
    required this.invoiceNumber,
    required this.storeId,
    required this.status,
    required this.invoiceDate,
    required this.transportName,
    required this.receivedDate,
    required this.supplierId,
    required this.supplierName,
  });

  factory UpcomingProductsModel.fromJson(Map<String, dynamic> json) =>
      UpcomingProductsModel(
        id: json["id"],
        invoiceNumber: json["invoiceNumber"].toString(),
        storeId: json["storeId"].toString(),
        status: json["Status"].toString(),
        invoiceDate: DateTime.parse(json["invoiceDate"]),
        transportName: json["transportName"].toString(),
        receivedDate: json["receivedDate"],
        supplierId: json["supplierId"].toString(),
        supplierName: json["supplierName"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNumber": invoiceNumber,
        "storeId": storeId,
        "Status": status,
        "invoiceDate":
            "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "transportName": transportName,
        "receivedDate": receivedDate,
        "supplierId": supplierId,
        "supplierName": supplierName,
      };
}
