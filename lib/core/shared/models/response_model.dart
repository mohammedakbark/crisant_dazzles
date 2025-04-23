
class ResponseModel {
  int status;
  String message;
  bool error;
  Object? data;
  // PaginationModel? pagination;

  ResponseModel({
    required this.data,
    required this.error,
    required this.message,
    required this.status,
    // this.pagination,
  });

  // Map<String, dynamic> toJson() => {
  //   'status': status,
  //   'message': message,
  //   'error': error,
  //   'data': data,
  //   'pagination': pagination.toJson(),
  // };

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      data: json['data'],
      error: json['error'],
      message: json['message'] ?? "",
      status: json['status'],
      // pagination: json['pagination'] != null
      //     ? PaginationModel.fromJson(json['pagination'])
      //     : null,
    );
  }
}
