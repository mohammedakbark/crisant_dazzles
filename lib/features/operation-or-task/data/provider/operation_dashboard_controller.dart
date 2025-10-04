import 'dart:async';

import 'package:dazzles/features/operation-or-task/data/model/operation_dashboard_model.dart';
import 'package:dazzles/features/operation-or-task/data/repo/get_operation_dashboard_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final operationDashboardControllerProvider = AsyncNotifierProvider<
    OperationDashboardController,
    OperationDashboardModel>(OperationDashboardController.new);

class OperationDashboardController
    extends AsyncNotifier<OperationDashboardModel> {
  @override
  FutureOr<OperationDashboardModel> build() {
    return getData();
  }

  Future<OperationDashboardModel> getData() async {
    state = AsyncValue.loading();
    final response =
        await GetOperationDashboardRepo.onFetchOperationDashboard();
    OperationDashboardModel data;

    if (response['error'] == false) {
      data = response['data'];
    } else {
      data = OperationDashboardModel(completedCount: 0, pendingCount: 0);
    }
    state = AsyncValue.data(data);
    return data;
  }
}
