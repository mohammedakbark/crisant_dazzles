class CarBrandModel {
    final int makeId;
    final String makeName;
    final String logo;
    final DateTime createdAt;
    final DateTime modifiedAt;

    CarBrandModel({
        required this.makeId,
        required this.makeName,
        required this.logo,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory CarBrandModel.fromJson(Map<String, dynamic> json) => CarBrandModel(
        makeId: json["makeId"],
        makeName: json["makeName"],
        logo: json["logo"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "makeId": makeId,
        "makeName": makeName,
        "logo": logo,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}