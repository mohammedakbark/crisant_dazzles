import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';

import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_state.dart';

import 'package:dazzles/features/operation-or-task/presentation/widgets/operation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOperationTaskScreen extends ConsumerStatefulWidget {
  const MyOperationTaskScreen({super.key});

  @override
  ConsumerState<MyOperationTaskScreen> createState() =>
      _OperationTaskViewScreenState();
}

class _OperationTaskViewScreenState
    extends ConsumerState<MyOperationTaskScreen> {
  late String currentUserId;

  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(operationControllerProvider);
      },
    );
    super.initState();
    _loadCurrentUser(); // load user id separately
    // start fetching controller data (no blocking UI)
    initController();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await LoginRefDataBase().getUserData;
      // convert to string or int depending on your model
      if (!mounted) return;
      setState(() {
        currentUserId = user.userId?.toString() ?? '';
      });
    } catch (e) {
      // handle if needed
      log('error loading user: $e');
    }
  }

  Future<void> initController() async {
    final notifier = ref.read(operationControllerProvider.notifier);

    Future.microtask(
      () {
        // notifier.getToDoOperationTask();
        notifier.getCreatedOperationsBySelf();
        notifier.fetchAllRoles();
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(operationControllerProvider);

    return Scaffold(
        appBar: AppBar(
          leading: AppBackButton(),
          title: AppBarText(title: "My Task"),
        ),
        // floatingActionButton:
        //     AppPermissionConfig().has(AppPermission.createoperationtask)
        //         ? FloatingActionButton(
        //             backgroundColor: AppColors.kTeal,
        //             child: const Icon(
        //               Icons.add,
        //               color: AppColors.kWhite,
        //             ),
        //             onPressed: () {
        //               context.push(creatNewOperationTaskScreen);
        //             })
        //         : null,
        body: BuildStateManageComponent(
          stateController: state,
          errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
          successWidget: (data) {
            final operationState = data as OperationState;

            final createdTask = operationState.createdOperations;
            return RefreshIndicator.adaptive(
              onRefresh: () async {},
              child: createdTask.isEmpty
                  ? Center(
                      child: AppErrorView(error: "No task found!"),
                    )
                  : _buildAssignedList(
                      createdTask, operationState.isFechingCreatedOperations),
            );
          },
        ));
  }
}

Widget _buildAssignedList(
    List<CreatedOperationModel> createdTask, bool isFechingCreatedOperations) {
  if (createdTask.isEmpty) return SizedBox();

  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 8),
        ...createdTask
            .map((t) => OperationTile(
                  isToDoTask: false,
                  createdTask: t,
                ))
            .toList(),
      ],
    ),
  );
}
