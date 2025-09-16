class DriverStoreModel {
    final int storeId;
    final String storeName;
    final String storeShortName;

    DriverStoreModel({
        required this.storeId,
        required this.storeName,
        required this.storeShortName,
    });

    factory DriverStoreModel.fromJson(Map<String, dynamic> json) => DriverStoreModel(
        storeId: json["storeId"],
        storeName: json["storeName"],
        storeShortName: json["storeShortName"],
    );

    Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "storeName": storeName,
        "storeShortName": storeShortName,
    };
}