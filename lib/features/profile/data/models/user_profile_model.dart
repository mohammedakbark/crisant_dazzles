class UserProfileModel {
    String username;
    String store;
    String role;
    String mode;
    String status;

    UserProfileModel({
        required this.username,
        required this.store,
        required this.role,
        required this.mode,
        required this.status,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        username: json["username"],
        store: json["store"],
        role: json["role"],
        mode: json["mode"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "store": store,
        "role": role,
        "mode": mode,
        "status": status,
    };
}
