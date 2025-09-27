import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/created_operartion_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_state.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/assign_operation_sheet.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/operation_complete_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OperationTile extends ConsumerWidget {
  final ToDoOperationModel? toDoTask;
  final CreatedOperationModel? createdTask;
  final bool isToDoTask;

  const OperationTile({
    super.key,
    required this.isToDoTask,
    this.createdTask,
    this.toDoTask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationControllerProvider);
    final theme = Theme.of(context);

    if (isToDoTask) {
      return _buildToDoTaskTile(context, ref, theme);
    } else {
      return _buildCreatedTaskTile(context, ref, state, theme);
    }
  }

  Widget _buildToDoTaskTile(
      BuildContext context, WidgetRef ref, ThemeData theme) {
    final taskStatus = _getTaskStatus(toDoTask!);
    final isEnabled = taskStatus == TaskStatus.active;
    final statusInfo = _getStatusInfo(taskStatus);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Card(
        elevation: isEnabled ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: statusInfo.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                statusInfo.backgroundColor.withOpacity(0.05),
                statusInfo.backgroundColor.withOpacity(0.02),
              ],
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: statusInfo.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSubmissionModeIcon(
                    toDoTask!.submissionType ?? SubmissionMode.text),
                color: statusInfo.iconColor,
                size: 28,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    toDoTask!.operationName ?? "Unknown Task",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isEnabled
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                    ),
                  ),
                ),
                _buildStatusChip(statusInfo, theme),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Information
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: statusInfo.iconColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${toDoTask!.startTime} - ${toDoTask!.endTime}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isEnabled
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.disabledColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Task Details
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _buildDetailChip(
                        'Mode: ${toDoTask!.submissionType?.name.toUpperCase() ?? "TEXT"}',
                        Icons.mode_edit,
                        theme,
                        isEnabled,
                      ),
                      _buildDetailChip(
                        'Gallery: ${toDoTask!.galleryAccess == 1 ? "Yes" : "No"}',
                        toDoTask!.galleryAccess == 1
                            ? Icons.photo_library
                            : Icons.camera_alt,
                        theme,
                        isEnabled,
                      ),
                    ],
                  ),

                  // Date Information (for once schedule)
                  if (toDoTask!.scheduleType == ScheduleType.once &&
                      toDoTask!.specialDate != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: statusInfo.iconColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Date: ${_formatSpecialDate(toDoTask!.specialDate)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isEnabled
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Assigned By Information
                  if (toDoTask!.assignedBy != null &&
                      toDoTask!.assignedBy!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: statusInfo.iconColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Assigned by: ${toDoTask!.assignedBy}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isEnabled
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Status Message
                  if (!isEnabled) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusInfo.backgroundColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusInfo.icon,
                            size: 14,
                            color: statusInfo.iconColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusInfo.message,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: statusInfo.iconColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            onTap: isEnabled
                ? () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // backgroundColor: Colors.transparent,
                      builder: (_) => Container(
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: OperationCompleteSheet(task: toDoTask!),
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCreatedTaskTile(BuildContext context, WidgetRef ref,
      AsyncValue<OperationState> state, ThemeData theme) {
    final isDeleting = state.value != null &&
        state.value!.waitingListForDeletingOperation
            .contains(createdTask!.operationId.toString());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.05),
                    theme.colorScheme.primary.withOpacity(0.02),
                  ],
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 60, 16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getSubmissionModeIcon(createdTask!.submissionType),
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        createdTask!.operationName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time Information
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${createdTask!.startTime} - ${createdTask!.endTime}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Task Details
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          _buildDetailChip(
                            'Mode: ${createdTask!.submissionType.name.toUpperCase()}',
                            Icons.mode_edit,
                            theme,
                            true,
                          ),
                          _buildDetailChip(
                            'Gallery: ${createdTask!.galleryAccess == 1 ? "Yes" : "No"}',
                            createdTask!.galleryAccess == 1
                                ? Icons.photo_library
                                : Icons.camera_alt,
                            theme,
                            true,
                          ),
                        ],
                      ),

                      // Date Information
                      if (createdTask!.scheduleType == ScheduleType.once &&
                          createdTask!.specialDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Date: ${_formatSpecialDate(createdTask!.specialDate)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Assigned Count
                      if (createdTask!.assignedTo.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Assigned to ${createdTask!.assignedTo.length} employees',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => Container(
                      child: AssignSheet(task: createdTask!),
                    ),
                  );
                },
              ),
            ),

            // Delete Button
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  InkWell(
                    onTap: isDeleting
                        ? null
                        : () {
                            _showDeleteConfirmation(context, ref);
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kErrorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.kErrorPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: isDeleting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.kErrorPrimary),
                              ),
                            )
                          : const Icon(
                              CupertinoIcons.delete,
                              size: 16,
                              color: AppColors.kErrorPrimary,
                            ),
                    ),
                  ),
                  AppSpacer(
                    hp: .01,
                  ),
                  InkWell(
                    onTap: () {
                      context.push(taskPerfomanceScreen, extra: {
                        "operationId": createdTask!.operationId.toString()
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.kWhite.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.person_3_fill,
                        size: 16,
                        color: AppColors.kWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text(
            'Are you sure you want to delete "${createdTask!.operationName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(operationControllerProvider.notifier)
                  .deleteOperation(createdTask!.operationId.toString());
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.kErrorPrimary,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(StatusInfo statusInfo, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusInfo.borderColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            size: 12,
            color: statusInfo.iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusInfo.status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusInfo.iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(
      String text, IconData icon, ThemeData theme, bool isEnabled) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: isEnabled
              ? theme.colorScheme.onSurfaceVariant
              : theme.disabledColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isEnabled
                ? theme.colorScheme.onSurfaceVariant
                : theme.disabledColor,
          ),
        ),
      ],
    );
  }

  TaskStatus _getTaskStatus(ToDoOperationModel task) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();

    // Parse start and end times
    final startTime = _parseTimeString(task.startTime ?? "00:00");
    final endTime = _parseTimeString(task.endTime ?? "23:59");

    // Check if schedule is once and compare dates
    if (task.scheduleType == ScheduleType.once) {
      if (task.specialDate == null) {
        return TaskStatus.expired;
      }

      final specialDate = _parseSpecialDate(task.specialDate);
      if (specialDate == null) {
        return TaskStatus.expired;
      }

      final today = DateTime(now.year, now.month, now.day);
      final taskDate =
          DateTime(specialDate.year, specialDate.month, specialDate.day);

      if (taskDate.isBefore(today)) {
        return TaskStatus.expired;
      } else if (taskDate.isAfter(today)) {
        return TaskStatus.upcoming;
      }
      // If taskDate equals today, check time
    }

    // Check time range for today (for daily tasks or once task on correct date)
    if (startTime != null && endTime != null) {
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      if (currentMinutes < startMinutes) {
        return TaskStatus.upcoming;
      } else if (currentMinutes > endMinutes) {
        return TaskStatus.expired;
      } else {
        return TaskStatus.active;
      }
    }

    return TaskStatus.active;
  }

  StatusInfo _getStatusInfo(TaskStatus status) {
    switch (status) {
      case TaskStatus.active:
        return StatusInfo(
          status: 'Active',
          message: 'Task is available now',
          icon: Icons.play_circle,
          iconColor: Colors.green,
          backgroundColor: Colors.green,
          borderColor: Colors.green,
        );
      case TaskStatus.upcoming:
        return StatusInfo(
          status: 'Upcoming',
          message: 'Task will be available later',
          icon: Icons.schedule,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange,
          borderColor: Colors.orange,
        );
      case TaskStatus.expired:
        return StatusInfo(
          status: 'Expired',
          message: 'Task time has passed',
          icon: Icons.warning_rounded,
          iconColor: Colors.grey,
          backgroundColor: Colors.grey,
          borderColor: Colors.grey,
        );
    }
  }

  TimeOfDay? _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Handle parsing error
    }
    return null;
  }

  DateTime? _parseSpecialDate(dynamic specialDate) {
    try {
      if (specialDate is String) {
        return DateTime.parse(specialDate);
      } else if (specialDate is DateTime) {
        return specialDate;
      }
    } catch (e) {
      // Handle parsing error
    }
    return null;
  }

  String _formatSpecialDate(dynamic specialDate) {
    final date = _parseSpecialDate(specialDate);
    if (date != null) {
      return DateFormat('MMM dd, yyyy').format(date);
    }
    return specialDate.toString();
  }

  IconData _getSubmissionModeIcon(SubmissionMode mode) {
    switch (mode) {
      case SubmissionMode.text:
        return Icons.text_fields;
      case SubmissionMode.image:
        return Icons.image;
      case SubmissionMode.video:
        return Icons.videocam;
      default:
        return Icons.task;
    }
  }
}

enum TaskStatus { active, upcoming, expired }

class StatusInfo {
  final String status;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  StatusInfo({
    required this.status,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
