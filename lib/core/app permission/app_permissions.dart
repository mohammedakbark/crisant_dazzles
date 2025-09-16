// lib/core/app_permission/app_permissions.dart
import 'dart:developer';
import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

class AppPermissionConfig {
  static final AppPermissionConfig _instance =
      AppPermissionConfig._internal();
  factory AppPermissionConfig() => _instance;
  AppPermissionConfig._internal();

  final Set<AppPermission> _permissions = {};

  Future<void> init() async {
    final loginRef = await LoginRefDataBase().getUserData;
    final rawKeys = Set<String>.from(loginRef.permissions ?? <String>[]);
    // convert to Set<AppPermission>
    final parsed = AppPermissionExt.fromKeySet(rawKeys);

    _permissions
      ..clear()
      ..addAll(parsed);

    log("-- permission initialization done -- ${_permissions.map((p) => p.toKey()).toList()}");
  }

  /// synchronous check (easy to use in UI / services)
  bool has(AppPermission permission) => _permissions.contains(permission);

  /// expose all current permissions
  Set<AppPermission> get all => _permissions;
}
