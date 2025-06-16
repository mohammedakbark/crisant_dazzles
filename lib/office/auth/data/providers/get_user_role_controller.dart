import 'dart:async';

import 'package:dazzles/office/auth/data/models/user_role_mode.dart';
import 'package:dazzles/office/auth/data/repo/get_roles_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserRoleController extends AsyncNotifier<List<UserRoleModel>> {
  @override
  FutureOr<List<UserRoleModel>> build() async {
    state = AsyncLoading();
    try {
      final response = await GetRolesRepo.onGetRoles();
      if (response['error'] == false) {
        final data = response['data'] as List<UserRoleModel>;
        final list = [UserRoleModel(roleId: 0000, roleName: "Office"), ...data];
        return list;
      } else {
        return [];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

final userRoleControllerProvider =
    AsyncNotifierProvider<GetUserRoleController, List<UserRoleModel>>(
  GetUserRoleController.new,
);
