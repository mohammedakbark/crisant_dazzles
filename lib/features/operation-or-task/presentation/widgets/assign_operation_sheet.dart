import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/empployee_model_for_operation.dart';
import 'package:dazzles/features/operation-or-task/data/model/operation_models.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignSheet extends ConsumerStatefulWidget {
  final CreatedOperationModel task;
  const AssignSheet({super.key, required this.task});

  @override
  ConsumerState<AssignSheet> createState() => _AssignSheetState();
}

class _AssignSheetState extends ConsumerState<AssignSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref.read(operationControllerProvider.notifier).clearAssignSheet();
      },
    );
  }

  EmployeeModelForOperation? selectedEmployee;
  Widget build(BuildContext context) {
    final state = ref.watch(operationControllerProvider);
    final notifier = ref.read(operationControllerProvider.notifier);
    if (state.value != null && state.value is OperationState) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppMargin(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacer(hp: .01),
                  Align(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.kTextPrimaryColor),
                    ),
                  ),
                  AppSpacer(hp: .01),
                  Text('Assign Task: ${widget.task.operationName}',
                      style: Theme.of(context).textTheme.headlineLarge),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<int>(
                          hint: const Text('Select Employee Role'),
                          items: state.value?.userRoles
                              .map((e) => DropdownMenuItem(
                                  value: e.roleId,
                                  child: Text('${e.roleName}')))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              notifier.onFetchEmployeeBasedRole(v.toString());
                            }
                          },
                        ),
                      ),
                      if (state.value!.isFechingEmployees) ...[
                        const SizedBox(width: 20),
                        const SizedBox(
                            width: 16, height: 16, child: AppLoading()),
                        const SizedBox(width: 10),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (state.value!.employees.isNotEmpty)
                    DropdownButtonFormField<EmployeeModelForOperation>(
                      value: state.value!.employees.isEmpty ||
                              selectedEmployee == null
                          ? null
                          : state.value?.employees.firstWhere(
                              (element) =>
                                  element.employeeId ==
                                  selectedEmployee?.employeeId,
                              orElse: () => state.value!.employees.first,
                            ),
                      hint: const Text('Select Employee'),
                      items: state.value?.employees
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text('${e.fullName}')))
                          .toList(),
                      onChanged: (v) {
                        selectedEmployee = v;

                        if (v != null) notifier.addToEmployeeList(v);
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (ref.watch(operationControllerProvider).value!.isShowingMessage)
              AppMargin(
                child: Text(
                  ref.watch(operationControllerProvider).value!.message,
                  style: AppStyle.boldStyle(
                      color:
                          ref.watch(operationControllerProvider).value!.isError
                              ? Colors.red
                              : Colors.green),
                ),
              ),
            const SizedBox(height: 8),
            if (state.value!.selectedEmployee.isNotEmpty) ...[
              // padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              // decoration: BoxDecoration(
              //   color: ,
              // ),
              Column(
                children: state.value!.selectedEmployee
                    .asMap()
                    .entries
                    .map((e) => Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 2),
                          child: ListTile(
                            minLeadingWidth: 0,
                            tileColor:
                                AppColors.kTextPrimaryColor.withAlpha(20),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Text(
                              '${e.key + 1}.',
                              style: AppStyle.boldStyle(fontSize: 15),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                notifier.removeFromEmployeeList(e.value);
                              },
                            ),
                            title: Text(
                              e.value.fullName,
                              style: AppStyle.boldStyle(),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),

              AppMargin(
                child: ElevatedButton(
                  onPressed: ref
                          .watch(operationControllerProvider)
                          .value!
                          .isLoadingAssigningOperation
                      ? null
                      : () async {
                          await notifier.assignOperationToUsers(
                              widget.task.operationId.toString(), context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kTeal,
                    foregroundColor: AppColors.kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: ref
                          .watch(operationControllerProvider)
                          .value!
                          .isLoadingAssigningOperation
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Assigning...',
                              style: AppStyle.boldStyle(),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: AppColors.kWhite,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Assign Task',
                              style: AppStyle.boldStyle(),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
