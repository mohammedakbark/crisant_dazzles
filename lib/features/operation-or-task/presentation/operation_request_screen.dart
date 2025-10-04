import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20request%20controller/operation_request_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20request%20controller/operation_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OperationRequestScreen extends ConsumerWidget {
  const OperationRequestScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final operationRequestController =
        ref.watch(operationRequestControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: AppBarText(title: "Operation Requests"),
      ),
      body: BuildStateManageComponent(
        stateController: operationRequestController,
        errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
        successWidget: (data) {
          final state = data as OperationRequestState;
          final requests = state.operationRequestList;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text(request.reason),
              );
            },
          );
        },
      ),
    );
  }
}
