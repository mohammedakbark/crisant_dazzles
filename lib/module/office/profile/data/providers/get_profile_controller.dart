import 'dart:async';

import 'package:dazzles/module/office/profile/data/models/user_profile_model.dart';
import 'package:dazzles/module/office/profile/data/repo/get_profile_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider =
    AsyncNotifierProvider<GetProfileController, UserProfileModel?>(
      GetProfileController.new,
    );

class GetProfileController extends AsyncNotifier<UserProfileModel?> {
  @override
  FutureOr<UserProfileModel?> build() async {
    try {
      final result = await GetProfileRepo.onGetProfileData();
      if (result['error'] == false) return result['data'];
      throw result['data'];
    } catch (e) {
      throw e.toString();
    }
  }
}
