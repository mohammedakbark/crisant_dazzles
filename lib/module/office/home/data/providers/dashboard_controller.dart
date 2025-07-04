import 'dart:async';

import 'package:dazzles/module/office/home/data/models/dashboard_model.dart';
import 'package:dazzles/module/office/home/data/repo/get_dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<GetDashboardController, DashboardModel>(
      GetDashboardController.new,
    );

class GetDashboardController extends AsyncNotifier<DashboardModel> {
  @override
  FutureOr<DashboardModel> build() async {
    try {
      state = AsyncValue.loading();
      final result = await GetDashboardDataRepo.onGetDashboard();
      if (result['error'] == false) return result['data'];
      throw result['data'];
    } catch (e) {
      throw e.toString();
    }
  }

}
