import 'dart:async';

import 'package:dazzles/features/operation-or-task/data/model/operation_request_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20request%20controller/operation_request_state.dart';
import 'package:dazzles/features/operation-or-task/data/repo/ask_request_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/get_operation_request_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final operationRequestControllerProvider =
    AsyncNotifierProvider<OperationRequestController, OperationRequestState>(
  OperationRequestController.new,
);

class OperationRequestController extends AsyncNotifier<OperationRequestState> {
  @override
  Future<OperationRequestState> build() async {
    return _fetchState();
  }

  /// Public method you can call from the UI to refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchState);
  }

  Future<OperationRequestState> _fetchState() async {
    final baseState = state.value ?? OperationRequestState();

    final response = await GetOperationRequestRepo.onFetchReuqests();
    if (response['error'] == false) {
      final List<OperationRequestModel> data =
          (response['data'] as List<OperationRequestModel>? ??
              <OperationRequestModel>[]);
      // state = AsyncData(baseState.copyWith(operationRequestList: data));
      return baseState.copyWith(operationRequestList: data);
    } else {
      throw response['data'] ??
          'Unknown error while fetching operation requests';
    }
  }

  Future<void> askRequestForReentry(
      BuildContext context, String reason, int operationRecordId) async {
    final response =
        await AskRequestRepo.requestForReEntry(operationRecordId, reason);
    if (response['error'] == false) {
    } else {}
  }

  void showMessage(String msg, {bool isError = false}) {
    final latest = state.value ?? OperationRequestState();
    state = AsyncData(latest.copyWith(
      isShowingMessage: true,
      message: msg,
      isError: isError,
    ));
    Timer(const Duration(seconds: 5), () {
      final latest = state.value ?? OperationRequestState();
      state = AsyncData(latest.copyWith(
        isShowingMessage: false,
        message: '',
        isError: false,
      ));
    });
  }
}
