class CarModelModel {
    final int modelId;
    final int makeId;
    final String modelName;
    final String modelFullName;
    final DateTime createdAt;
    final DateTime modifiedAt;

    CarModelModel({
        required this.modelId,
        required this.makeId,
        required this.modelName,
        required this.modelFullName,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory CarModelModel.fromJson(Map<String, dynamic> json) => CarModelModel(
        modelId: json["modelId"],
        makeId: json["makeId"],
        modelName: json["modelName"],
        modelFullName: json["modelFullName"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "modelId": modelId,
        "makeId": makeId,
        "modelName": modelName,
        "modelFullName": modelFullName,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}