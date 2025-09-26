import 'dart:async';
import 'dart:developer';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/Auth/data/models/user_role_mode.dart';
import 'package:dazzles/features/Auth/data/repo/get_roles_repo.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/create_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/empployee_model_for_operation.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_state.dart';
import 'package:dazzles/features/operation-or-task/data/repo/assign_operation_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/create_new_operation_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/delete_operation_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/get_assigned_operations_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/get_created_operations_repo.dart';
import 'package:dazzles/features/operation-or-task/data/repo/get_role_based_employees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final operationControllerProvider =
    AsyncNotifierProvider<OperationController, OperationState>(
        OperationController.new);

class OperationController extends AsyncNotifier<OperationState> {
  @override
  FutureOr<OperationState> build() {
    return OperationState();
  } // API INTEGRATION

  Future<void> getCreatedOperationsBySelf() async {
    final baseState = state.value ?? OperationState();

    state =
        AsyncValue.data(baseState.copyWith(isFechingCreatedOperations: true));

    try {
      final response =
          await GetCreatedOperationsRepo.onFetchCreatedOperations();

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        final createdOperations =
            response['data'] as List<CreatedOperationModel>;
        state = AsyncValue.data(latest.copyWith(
          createdOperations: createdOperations,
          isFechingCreatedOperations: false,
        ));
        log("Created operations fetched: ${createdOperations.length}");
      } else {
        state =
            AsyncValue.data(latest.copyWith(isFechingCreatedOperations: false));
        log("error fetching created operations: ${response['data']}");
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state =
          AsyncValue.data(latest.copyWith(isFechingCreatedOperations: false));
      log("error fetching created operations: $e\n$st");
    }
  }

  Future<void> getToDoOperationTask() async {
    final baseState = state.value ?? OperationState();

    state = AsyncValue.data(baseState.copyWith(isFetchingToDoOperations: true));

    try {
      final response = await GetToDoOperationTask.onFetchToDoOperationTask();

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        final toDoOperationsTask = response['data'] as List<ToDoOperationModel>;
        state = AsyncValue.data(latest.copyWith(
          toDoOperationsTask: toDoOperationsTask,
          isFetchingToDoOperations: false,
        ));
        log("To do operations fetched: ${toDoOperationsTask.length}");
      } else {
        state =
            AsyncValue.data(latest.copyWith(isFetchingToDoOperations: false));
        log("error fetching to do operations: ${response['data']}");
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state = AsyncValue.data(latest.copyWith(isFetchingToDoOperations: false));
      log("error fetching to do operations: $e\n$st");
    }
  }

  Future<void> onCreateNewOperationTask(
      CreateOperationModel model, BuildContext context) async {
    final baseState = state.value ?? OperationState();
    state =
        AsyncValue.data(baseState.copyWith(isCreatingOperationLoading: true));

    try {
      final response = await CreateNewOperationRepo.onCreateNewOperation(model);

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        state =
            AsyncValue.data(latest.copyWith(isCreatingOperationLoading: false));
        await getCreatedOperationsBySelf();
        showCustomSnackBarAdptive("Operation created successfully",
            isError: false);

        context.pop();
        log("Operation created successfully");
      } else {
        state =
            AsyncValue.data(latest.copyWith(isCreatingOperationLoading: false));
        log("error creating operation: ${response['data']}");
        showCustomSnackBarAdptive(response['data'], isError: true);
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state =
          AsyncValue.data(latest.copyWith(isCreatingOperationLoading: false));
      showCustomSnackBarAdptive("error creating operation: $e\n$st",
          isError: true);
      log("error creating operation: $e\n$st");
    }
  }

  Future<void> assignOperationToUsers(
      String operationId, BuildContext context) async {
    final baseState = state.value ?? OperationState();
    state =
        AsyncValue.data(baseState.copyWith(isLoadingAssigningOperation: true));

    try {
      final response = await AssignOperationRepo.assignOperation(
          operationId,
          baseState.selectedEmployee
              .map((e) => e.employeeId.toString())
              .toList());

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        state = AsyncValue.data(
            latest.copyWith(isLoadingAssigningOperation: false));
        await getCreatedOperationsBySelf();
        showCustomSnackBarAdptive("Task assigned", isError: false);
        context.pop();
        log("Task assigned successfully");
      } else {
        state = AsyncValue.data(
            latest.copyWith(isLoadingAssigningOperation: false));
        log("error assigning operation: ${response['data']}");
        showCustomSnackBarAdptive(response['data'], isError: true);
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state =
          AsyncValue.data(latest.copyWith(isLoadingAssigningOperation: false));
      showCustomSnackBarAdptive("error assigning operation: $e\n$st",
          isError: true);
      log("error assigning operation: $e\n$st");
    }
  }

  Future<void> deleteOperation(String operationId) async {
    // defensive copy of current state to avoid mutating lists held by state directly
    final baseState = state.value ?? OperationState();
    final currentlyDeleting = List<String>.from(
      baseState.waitingListForDeletingOperation,
    );

    // optimistic update: add id to deleting list and emit new state
    if (!currentlyDeleting.contains(operationId)) {
      currentlyDeleting.add(operationId);
      state = AsyncValue.data(
        baseState.copyWith(waitingListForDeletingOperation: currentlyDeleting),
      );
    }

    try {
      final Map<String, dynamic> response =
          await DeleteOperationRepo.onDeleteOperation(operationId);

      // response handling
      final bool error = response['error'] == true;
      final String message =
          (response['data'] ?? response['message'] ?? '').toString();

      if (!error) {
        // success: refresh list of operations
        await getCreatedOperationsBySelf();
        log('Deleted operation $operationId successfully');
        // optional: show success snackbar
        showCustomSnackBarAdptive(
            message.isNotEmpty ? message : "Deleted successfully",
            isError: false);
      } else {
        // backend returned an error
        log('Error deleting operation $operationId: $message');
        showCustomSnackBarAdptive(
            message.isNotEmpty ? message : "Error deleting operation",
            isError: true);
      }
    } catch (e, st) {
      log('Exception deleting operation $operationId: $e\n$st');
      showCustomSnackBarAdptive('Error deleting operation: $e', isError: true);
    } finally {
      // ensure the id is removed from the waiting list and state is updated
      final latest = state.value ?? OperationState();
      final newWaiting =
          List<String>.from(latest.waitingListForDeletingOperation);

      if (newWaiting.contains(operationId)) {
        newWaiting.remove(operationId);
        state = AsyncValue.data(
          latest.copyWith(waitingListForDeletingOperation: newWaiting),
        );
      } else {
        // make sure state still reflects the latest list even if id already removed
        state = AsyncValue.data(
            latest.copyWith(waitingListForDeletingOperation: newWaiting));
      }
    }
  }

  //.  Other methods related to operations can be added here

  Future<void> fetchAllRoles() async {
    final baseState = state.value ?? OperationState();

    state = AsyncValue.data(baseState.copyWith(isFechingUserRoles: true));

    try {
      final response = await GetRolesRepo.onGetRoles();

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        final userRoles = response['data'] as List<UserRoleModel>;
        state = AsyncValue.data(latest.copyWith(
          userRoles: userRoles,
          isFechingUserRoles: false,
        ));
        log("User roles fetched: ${userRoles.length}");
      } else {
        state = AsyncValue.data(latest.copyWith(isFechingUserRoles: false));
        log("error fetching user roles: ${response['message']}");
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state = AsyncValue.data(latest.copyWith(isFechingUserRoles: false));
      log("error fetching user roles: $e\n$st");
    }
  }

  Future<void> onFetchEmployeeBasedRole(String roleId) async {
    final baseState = state.value ?? OperationState();

    state = AsyncValue.data(baseState.copyWith(isFechingEmployees: true));

    try {
      final response =
          await GetRoleBasedEmployees.onFetchRoleBasedEmployee(roleId);

      final latest = state.value ?? OperationState();

      if (response['error'] == false) {
        final employees = response['data'] as List<EmployeeModelForOperation>;
        state = AsyncValue.data(latest.copyWith(
          employees: employees,
          isFechingEmployees: false,
        ));
        log(" fetched employees : ${employees.length}");
      } else {
        state = AsyncValue.data(latest.copyWith(isFechingEmployees: false));
        log("error fetching employees: ${response['message']}");
      }
    } catch (e, st) {
      final latest = state.value ?? OperationState();
      state = AsyncValue.data(latest.copyWith(isFechingEmployees: false));
      log("error fetching employees: $e\n$st");
    }
  }

  void addToEmployeeList(EmployeeModelForOperation employeeModel) {
    final baseState = state.value ?? OperationState();
    final currentSelected = List<EmployeeModelForOperation>.from(
      baseState.selectedEmployee,
    );

    if (!currentSelected.contains(employeeModel)) {
      currentSelected.add(employeeModel);
      state = AsyncValue.data(
          baseState.copyWith(selectedEmployee: currentSelected));
    }
  }

  void removeFromEmployeeList(EmployeeModelForOperation employeeModel) {
    final baseState = state.value ?? OperationState();
    final currentSelected = List<EmployeeModelForOperation>.from(
      baseState.selectedEmployee,
    );

    if (currentSelected.contains(employeeModel)) {
      currentSelected.remove(employeeModel);
      state = AsyncValue.data(
          baseState.copyWith(selectedEmployee: currentSelected));
    }
  }

  clearAssignSheet() {
    final baseState = state.value ?? OperationState();

    state = AsyncValue.data(baseState.copyWith(
      selectedEmployee: [],
      employees: [],
      isLoadingAssigningOperation: false,
      isFechingEmployees: false,
    ));
  }
}
