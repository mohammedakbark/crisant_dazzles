class SupplierModel {
    int id;
    String invoiceNumber;
    int storeId;
    String status;
    DateTime invoiceDate;
    String transportName;
    DateTime? receivedDate;
    String supplierId;

    SupplierModel({
        required this.id,
        required this.invoiceNumber,
        required this.storeId,
        required this.status,
        required this.invoiceDate,
        required this.transportName,
        required this.receivedDate,
        required this.supplierId,
    });

    factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json["id"],
        invoiceNumber: json["invoiceNumber"],
        storeId: json["storeId"],
        status: json["Status"],
        invoiceDate: DateTime.parse(json["invoiceDate"]),
        transportName: json["transportName"],
        receivedDate: json["receivedDate"],
        supplierId: json["supplierId"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNumber": invoiceNumber,
        "storeId": storeId,
        "Status": status,
        "invoiceDate": "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "transportName": transportName,
        "receivedDate": receivedDate,
        "supplier": supplierId,
    };
}