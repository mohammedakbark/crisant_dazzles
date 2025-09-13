class LocalUserRefModel {
  final String? userName;
  final String? token;
  final int? userId;
  final String? pushToken;
  final String? role;
  final int? roleId;
  final List<String>? permissions;

  LocalUserRefModel(
      {this.userName,
      this.token,
      this.userId,
      this.pushToken,
      this.role,
      this.permissions,
      this.roleId});
}
