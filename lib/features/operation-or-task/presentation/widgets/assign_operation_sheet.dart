import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(operationControllerProvider);
    final notifier = ref.read(operationControllerProvider.notifier);
    if (state.value != null && state.value is OperationState) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            children: [
              Text('Assign Task: ${widget.task.operationName}',
                  style: Theme.of(context).textTheme.headlineLarge),
              AppSpacer(hp: .07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: DropdownButtonFormField<int>(
                      hint: const Text('Select Employee Role'),
                      items: state.value?.userRoles
                          .map((e) => DropdownMenuItem(
                              value: e.roleId, child: Text('${e.roleName}')))
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
                    const SizedBox(width: 16, height: 16, child: AppLoading()),
                    const SizedBox(width: 10),
                  ]
                ],
              ),
              AppSpacer(hp: .07),
              DropdownButtonFormField<EmployeeModelForOperation>(
                hint: const Text('Select Employee'),
                items: state.value?.employees
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text('${e.fullName}')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) notifier.addToEmployeeList(v);
                },
              ),
              AppSpacer(hp: .07),
              if (state.value!.employees.isNotEmpty) ...[
                Container(
                  child: Column(
                    children: state.value!.selectedEmployee
                        .asMap()
                        .entries
                        .map((e) => ListTile(
                          
                              contentPadding: EdgeInsets.all(0),
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
                            ))
                        .toList(),
                  ),
                ),
                AppSpacer(hp: .07),
                AppSpacer(hp: .06),
                AppButton(
                    title: "Assign Task",
                    onPressed: () async {
                      await notifier.assignOperationToUsers(
                          widget.task.operationId.toString(), context);
                    })
              ],
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
