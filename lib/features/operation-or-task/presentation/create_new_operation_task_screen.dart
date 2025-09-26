import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/create_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateNewOperationTaskScreen extends ConsumerStatefulWidget {
  const CreateNewOperationTaskScreen({super.key});

  @override
  ConsumerState<CreateNewOperationTaskScreen> createState() =>
      _CreateNewOperationTaskScreenState();
}

class _CreateNewOperationTaskScreenState
    extends ConsumerState<CreateNewOperationTaskScreen> {
  final _nameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _fromTime;
  DateTime? _toTime;
  SubmissionMode _submissionMode = SubmissionMode.text;
  bool _allowGallery = false;
  ScheduleType _scheduleType = ScheduleType.once;
  DateTime? _specificDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default specific date to today if schedule type is once
    _specificDate = DateTime.now();
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final now = DateTime.now();
    TimeOfDay initialTime;

    if (isFrom) {
      initialTime = _fromTime != null
          ? TimeOfDay.fromDateTime(_fromTime!)
          : TimeOfDay.now();
    } else {
      // If picking "to time" and "from time" is already set,
      // start from "from time" + 1 hour as initial time
      if (_fromTime != null) {
        final fromTimeOfDay = TimeOfDay.fromDateTime(_fromTime!);
        initialTime = TimeOfDay(
          hour: (fromTimeOfDay.hour + 1) % 24,
          minute: fromTimeOfDay.minute,
        );
      } else {
        initialTime = TimeOfDay.now();
      }
    }

    final t = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: isFrom ? 'Select Start Time' : 'Select End Time',
    );

    if (t == null) return;

    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);

    // Validation: Ensure "to time" is after "from time"
    if (!isFrom && _fromTime != null) {
      if (dt.isBefore(_fromTime!) || dt.isAtSameMomentAs(_fromTime!)) {
        _showErrorSnackBar('End time must be after start time');
        return;
      }
    }

    setState(() {
      if (isFrom) {
        _fromTime = dt;
        // Reset "to time" if it's now invalid
        if (_toTime != null && _toTime!.isBefore(dt)) {
          _toTime = null;
        }
      } else {
        _toTime = dt;
      }
    });
  }

  Future<void> _pickSpecificDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _specificDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select Task Date',
    );
    if (d != null) {
      setState(() => _specificDate = d);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _validateTaskName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task name is required';
    }
    if (value.trim().length < 3) {
      return 'Task name must be at least 3 characters';
    }
    if (value.trim().length > 50) {
      return 'Task name must be less than 50 characters';
    }
    return null;
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_fromTime == null) {
      _showErrorSnackBar('Please select start time');
      return false;
    }

    if (_toTime == null) {
      _showErrorSnackBar('Please select end time');
      return false;
    }

    if (_scheduleType == ScheduleType.once && _specificDate == null) {
      _showErrorSnackBar('Please select a specific date');
      return false;
    }

    // Additional validation: Check if the task duration is reasonable
    final duration = _toTime!.difference(_fromTime!);
    if (duration.inMinutes < 15) {
      _showErrorSnackBar('Task duration should be at least 15 minutes');
      return false;
    }

    if (duration.inHours > 12) {
      _showErrorSnackBar('Task duration cannot exceed 12 hours');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(operationControllerProvider);
    final notifier = ref.read(operationControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Operation Task'),
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      body: BuildStateManageComponent(
        stateController: state,
        errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
        successWidget: (data) {
          final operationData = data as OperationState;
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Task Name Section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            isOutlineBorder: true,
                            controller: _nameC,
                            isTextCapital: false,
                            hintText: 'Enter task name',
                            validator: _validateTaskName,
                            prefixIcon: const Icon(Icons.task_alt),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Time Selection Section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Schedule',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickTime(isFrom: true),
                                  icon: const Icon(
                                    Icons.access_time,
                                    color: AppColors.kWhite,
                                  ),
                                  label: Text(
                                    _fromTime == null
                                        ? 'Start Time'
                                        : TimeOfDay.fromDateTime(_fromTime!)
                                            .format(context),
                                    style: AppStyle.boldStyle(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _fromTime != null
                                        ? AppColors.kTeal
                                        : AppColors.kTeal.withAlpha(20),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickTime(isFrom: false),
                                  icon: const Icon(
                                    Icons.access_time_filled,
                                    color: AppColors.kWhite,
                                  ),
                                  label: Text(
                                    _toTime == null
                                        ? 'End Time'
                                        : TimeOfDay.fromDateTime(_toTime!)
                                            .format(context),
                                    style: AppStyle.boldStyle(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _toTime != null
                                        ? AppColors.kTeal
                                        : AppColors.kTeal.withAlpha(20),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_fromTime != null && _toTime != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Duration: ${_toTime!.difference(_fromTime!).inMinutes} minutes',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submission Mode Section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submission Mode',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...SubmissionMode.values.map((mode) =>
                              RadioListTile<SubmissionMode>(
                                fillColor:
                                    WidgetStatePropertyAll(AppColors.kTeal),
                                title: Text(_getSubmissionModeLabel(mode)),
                                subtitle:
                                    Text(_getSubmissionModeDescription(mode)),
                                secondary: Icon(_getSubmissionModeIcon(mode)),
                                value: mode,
                                groupValue: _submissionMode,
                                onChanged: (v) =>
                                    setState(() => _submissionMode = v!),
                                contentPadding: EdgeInsets.zero,
                              )),
                          if (_submissionMode != SubmissionMode.text) ...[
                            const Divider(),
                            SwitchListTile(
                              activeColor: AppColors.kTeal,
                              title: const Text('Allow Gallery Access'),
                              subtitle: const Text(
                                'If disabled, only camera will be available',
                              ),
                              value: _allowGallery,
                              onChanged: (v) =>
                                  setState(() => _allowGallery = v),
                              secondary: const Icon(Icons.photo_library),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Schedule Type Section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recurrence',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RadioListTile<ScheduleType>(
                            fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                            title: const Text('Specific Date'),
                            subtitle: const Text('Run once on a specific date'),
                            secondary: const Icon(Icons.calendar_today),
                            value: ScheduleType.once,
                            groupValue: _scheduleType,
                            onChanged: (v) =>
                                setState(() => _scheduleType = v!),
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<ScheduleType>(
                            fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                            title: const Text('Daily'),
                            subtitle: const Text('Repeat every day'),
                            secondary: const Icon(Icons.repeat),
                            value: ScheduleType.daily,
                            groupValue: _scheduleType,
                            onChanged: (v) =>
                                setState(() => _scheduleType = v!),
                            contentPadding: EdgeInsets.zero,
                          ),
                          if (_scheduleType == ScheduleType.once) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _pickSpecificDate,
                                icon: const Icon(
                                  Icons.date_range,
                                  color: AppColors.kWhite,
                                ),
                                label: Text(
                                  _specificDate == null
                                      ? 'Select Date'
                                      : 'Date: ${_specificDate!.toLocal().toString().split(' ')[0]}',
                                  style: AppStyle.boldStyle(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _specificDate != null
                                      ? AppColors.kTeal
                                      : AppColors.kTeal.withAlpha(20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Create Button

                  _isLoading
                      ? const Row(
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
                            Text('Creating Task...'),
                          ],
                        )
                      : AppButton(
                          title: 'Create Task',
                          onPressed: _isLoading ? null : _createTask,
                        ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _createTask() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(operationControllerProvider.notifier);
      await notifier.onCreateNewOperationTask(
        CreateOperationModel(
          operationName: _nameC.text.trim(),
          scheduleType: _scheduleType,
          specialDate: _scheduleType == ScheduleType.once
              ? IntlC.convertToYearMonthDay(_specificDate!)
              : null,
          submissionType: _submissionMode,
          galleryAccess: _allowGallery ? 1 : 0,
          startTime: IntlC.convertToTime(_fromTime!),
          endTime: IntlC.convertToTime(_toTime!),
        ),
        context,
      );
    } catch (e) {
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getSubmissionModeLabel(SubmissionMode mode) {
    switch (mode) {
      case SubmissionMode.text:
        return 'Text';
      case SubmissionMode.image:
        return 'Image';
      case SubmissionMode.video:
        return 'Video';
    }
  }

  String _getSubmissionModeDescription(SubmissionMode mode) {
    switch (mode) {
      case SubmissionMode.text:
        return 'Text-based submission';
      case SubmissionMode.image:
        return 'Image upload required';
      case SubmissionMode.video:
        return 'Video upload required';
    }
  }

  IconData _getSubmissionModeIcon(SubmissionMode mode) {
    switch (mode) {
      case SubmissionMode.text:
        return Icons.text_fields;
      case SubmissionMode.image:
        return Icons.image;
      case SubmissionMode.video:
        return Icons.videocam;
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    super.dispose();
  }
}
