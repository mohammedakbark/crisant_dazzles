import 'dart:async';
import 'dart:developer';

import 'package:dazzles/features/Auth/data/models/user_role_mode.dart';
import 'package:dazzles/features/Auth/data/repo/get_roles_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserRoleController extends AsyncNotifier<List<UserRoleModel>> {
  @override
  FutureOr<List<UserRoleModel>> build() async {
    state = AsyncLoading();
    try {
      final response = await GetRolesRepo.onGetRoles();
      if (response['error'] == false) {
        final data = response['data'] as List<UserRoleModel>;
        // log(data.length.toString());
        final first = [UserRoleModel(roleId: 0000, roleName: "Office")];
        final list = [...first, ...data];
        // log(list.length.toString());
        state = AsyncValue.data(list);
        return list;
      } else {
        state = AsyncValue.data([]);
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
