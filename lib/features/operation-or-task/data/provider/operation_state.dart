import 'package:dazzles/features/Auth/data/models/user_role_mode.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/empployee_model_for_operation.dart';

class OperationState {
  final bool isFechingCreatedOperations;
  final bool isFetchingToDoOperations;
  final bool isCreatingOperationLoading;
  final bool isLoadingAssigningOperation;
  final bool isFechingUserRoles;
  final bool isFechingEmployees;
  List<String> waitingListForDeletingOperation;
  final List<CreatedOperationModel> createdOperations;
  final List<ToDoOperationModel> toDoOperationsTask;
  final List<UserRoleModel> userRoles;
  final List<EmployeeModelForOperation> employees;
  final List<EmployeeModelForOperation> selectedEmployee;

  OperationState({
    this.isFechingCreatedOperations = false,
    this.isFetchingToDoOperations = false,
    this.isCreatingOperationLoading = false,
    this.isLoadingAssigningOperation = false,
    this.isFechingUserRoles = false,
    this.isFechingEmployees = false,
    this.waitingListForDeletingOperation = const [],
    this.createdOperations = const [],
    this.toDoOperationsTask = const [],
    this.userRoles = const [],
    this.employees = const [],
    this.selectedEmployee = const [],
  });

  OperationState copyWith(
      {bool? isFechingCreatedOperations,
      bool? isFetchingToDoOperations,
      bool? isCreatingOperationLoading,
      bool? isLoadingAssigningOperation,
      bool? isFechingUserRoles,
      bool? isFechingEmployees,
      List<String>? waitingListForDeletingOperation,
      List<CreatedOperationModel>? createdOperations,
      List<ToDoOperationModel>? toDoOperationsTask,
      List<UserRoleModel>? userRoles,
      List<EmployeeModelForOperation>? employees,
      List<EmployeeModelForOperation>? selectedEmployee}) {
    return OperationState(
        isFechingCreatedOperations:
            isFechingCreatedOperations ?? this.isFechingCreatedOperations,
        isFetchingToDoOperations:
            isFetchingToDoOperations ?? this.isFetchingToDoOperations,
        isCreatingOperationLoading:
            isCreatingOperationLoading ?? this.isCreatingOperationLoading,
        isLoadingAssigningOperation:
            isLoadingAssigningOperation ?? this.isLoadingAssigningOperation,
        isFechingEmployees: isFechingEmployees ?? this.isFechingEmployees,
        isFechingUserRoles: isFechingUserRoles ?? this.isFechingUserRoles,
        waitingListForDeletingOperation: waitingListForDeletingOperation ??
            this.waitingListForDeletingOperation,
        createdOperations: createdOperations ?? this.createdOperations,
        toDoOperationsTask: toDoOperationsTask ?? this.toDoOperationsTask,
        userRoles: userRoles ?? this.userRoles,
        employees: employees ?? this.employees,
        selectedEmployee: selectedEmployee ?? this.selectedEmployee);
  }
}
