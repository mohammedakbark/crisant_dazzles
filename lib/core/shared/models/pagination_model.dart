class PaginationModel {
    int total;
    int currentPage;
    int totalPages;
    bool hasMore;

    PaginationModel({
        required this.total,
        required this.currentPage,
        required this.totalPages,
        required this.hasMore,
    });

    factory PaginationModel.fromJson(Map<String, dynamic> json) => PaginationModel(
        total: json["total"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        hasMore: json["hasMore"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "hasMore": hasMore,
    };
}