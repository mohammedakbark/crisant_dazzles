import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/assign_operation_sheet.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/operation_complete_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

class OperationTile extends ConsumerWidget {
  final ToDoOperationModel? toDoTask;
  final CreatedOperationModel? createdTask;
  final bool isToDoTask;
  const OperationTile(
      {super.key, required this.isToDoTask, this.createdTask, this.toDoTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationControllerProvider);
    if (isToDoTask) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(toDoTask!.operationName ?? ""),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${toDoTask!.startTime} - ${toDoTask!.endTime}'),
            Text(
                'Mode: ${toDoTask!.submissionType != null ? toDoTask!.submissionType!.name.toUpperCase() : ""} | Gallery: ${toDoTask!.galleryAccess == 1 ? "Yes" : "No"}'),
            if (toDoTask!.scheduleType == ScheduleType.once &&
                toDoTask!.specialDate != null)
              Text('Date: ${toDoTask!.specialDate}'),
          ]),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: OperationCompleteSheet(task: toDoTask!),
              ),
            );
          },
        ),
      );
    } else {
      return Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(createdTask!.operationName),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${createdTask!.startTime} - ${createdTask!.endTime}'),
                    Text(
                        'Mode: ${createdTask!.submissionType.name.toUpperCase()} | Gallery: ${createdTask!.galleryAccess == 1 ? "Yes" : "No"}'),
                    if (createdTask!.scheduleType == ScheduleType.once &&
                        createdTask!.specialDate != null)
                      Text('Date: ${createdTask!.specialDate}'),
                  ]),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => AssignSheet(task: createdTask!),
                );
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: InkWell(
              onTap: () {
                // Delete assigned task
                ref
                    .read(operationControllerProvider.notifier)
                    .deleteOperation(createdTask!.operationId.toString());
              },
              child: Card(
                color: AppColors.kErrorPrimary.withAlpha(50),
                child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: state.value != null &&
                            state.value!.waitingListForDeletingOperation
                                .contains(createdTask!.operationId.toString())
                        ? AppLoading()
                        : Icon(
                            CupertinoIcons.delete,
                            size: 15,
                          )),
              ),
            ),
          )
        ],
      );
    }
  }
}
