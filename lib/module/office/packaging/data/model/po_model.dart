class PoModel {
    int id;
    String invoiceNumber;
    int storeId;
    String status;
    DateTime invoiceDate;
    String transportName;
    DateTime? receivedDate;
    String supplier;

    PoModel({
        required this.id,
        required this.invoiceNumber,
        required this.storeId,
        required this.status,
        required this.invoiceDate,
        required this.transportName,
        required this.receivedDate,
        required this.supplier,
    });

    factory PoModel.fromJson(Map<String, dynamic> json) => PoModel(
        id: json["id"],
        invoiceNumber: json["invoiceNumber"],
        storeId: json["storeId"],
        status: json["Status"],
        invoiceDate: DateTime.parse(json["invoiceDate"]),
        transportName: json["transportName"],
        receivedDate: json["receivedDate"],
        supplier: json["supplier"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNumber": invoiceNumber,
        "storeId": storeId,
        "Status": status,
        "invoiceDate": "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "transportName": transportName,
        "receivedDate": receivedDate,
        "supplier": supplier,
    };
}