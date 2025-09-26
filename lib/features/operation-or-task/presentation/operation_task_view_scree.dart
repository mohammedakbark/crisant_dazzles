import 'dart:developer';

import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_state.dart';

import 'package:dazzles/features/operation-or-task/presentation/widgets/operation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OperationTaskViewScreen extends ConsumerStatefulWidget {
  const OperationTaskViewScreen({super.key});

  @override
  ConsumerState<OperationTaskViewScreen> createState() =>
      _OperationTaskViewScreenState();
}

class _OperationTaskViewScreenState
    extends ConsumerState<OperationTaskViewScreen> {
  late String currentUserId;

  @override
  void initState() {
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
        notifier.getToDoOperationTask();
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
          title: AppBarText(title: "Operations"),
        ),
        floatingActionButton:
            AppPermissionConfig().has(AppPermission.createoperationtask)
                ? FloatingActionButton(
                    backgroundColor: AppColors.kTeal,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.kWhite,
                    ),
                    onPressed: () {
                      context.push(creatNewOperationTaskScreen);
                    })
                : null,
        body: BuildStateManageComponent(
          stateController: state,
          errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
          successWidget: (data) {
            final operationState = data as OperationState;

            final myTasks = operationState.toDoOperationsTask;
            final createdTask = operationState.createdOperations;
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                // if you want call refresh action
                // ref.read(operationControllerProvider.notifier).expireTasks();
              },
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  // Tasks assigned to me to Complete
                  _buildToDoTaskList(
                      myTasks, operationState.isFetchingToDoOperations),

                  // Created task to some other employees to do
                  _buildAssignedList(
                      createdTask, operationState.isFechingCreatedOperations)
                ],
              ),
            );
          },
        ));
  }
}

Widget _buildToDoTaskList(
    List<ToDoOperationModel> myTasks, bool isFetchingToDoOperations) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Tasks To Do',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (isFetchingToDoOperations) AppLoading()
        ],
      ),
      if (myTasks.isEmpty)
        SizedBox(
            height: 100,
            child: Center(child: Text('No tasks assigned to you.'))),
      const SizedBox(height: 8),
      ...myTasks
          .map((t) => OperationTile(
                isToDoTask: true,
                toDoTask: t,
              ))
          .toList(),
      const SizedBox(height: 16),
    ],
  );
}

Widget _buildAssignedList(
    List<CreatedOperationModel> createdTask, bool isFechingCreatedOperations) {
  if (createdTask.isEmpty) return SizedBox();

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Assigned Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (isFechingCreatedOperations) AppLoading()
        ],
      ),
      const SizedBox(height: 8),
      ...createdTask
          .map((t) => OperationTile(
                isToDoTask: false,
                createdTask: t,
              ))
          .toList(),
    ],
  );
}
