import 'dart:async';

import 'package:dazzles/features/recently%20uploded/data/model/recently_captured.dart';
import 'package:dazzles/features/recently%20uploded/data/repo/get_recently_captured_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recntlyCapturedControllerProvider = AsyncNotifierProvider<
  RecentlyCapturedController,
  List<RecentCapturedModel>
>(RecentlyCapturedController.new);

class RecentlyCapturedController
    extends AsyncNotifier<List<RecentCapturedModel>> {
  @override
  FutureOr<List<RecentCapturedModel>> build() async {
    try {
      state = AsyncValue.loading();
      final result = await GetRecentlyCapturedRepo.onGetRecentlyCaptured();
      if (result['error'] == false) return result['data'];
      throw result['data'];
    } catch (e) {
      throw e.toString();
    }
  }
}
