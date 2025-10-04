import 'package:dazzles/features/operation-or-task/data/model/operation_request_model.dart';

class OperationRequestState {
  final List<OperationRequestModel> operationRequestList;
  final bool isShowingMessage;
  final String message;
  final bool isError;
  OperationRequestState(
      {this.operationRequestList = const [],
      this.isShowingMessage = false,
      this.message = "",
      this.isError = false});

  OperationRequestState copyWith(
      {List<OperationRequestModel>? operationRequestList,
      bool? isError,
      String? message,
      bool? isShowingMessage}) {
    return OperationRequestState(
        isError: isError ?? this.isError,
        isShowingMessage: isShowingMessage ?? this.isShowingMessage,
        message: message ?? this.message,
        operationRequestList:
            operationRequestList ?? this.operationRequestList);
  }
}
