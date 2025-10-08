class UserRoleModel {
  final int roleId;
  final String roleName;

  UserRoleModel({
    required this.roleId,
    required this.roleName,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
        roleId: json["roleId"] ?? "",
        roleName: json["roleName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
      };
}
