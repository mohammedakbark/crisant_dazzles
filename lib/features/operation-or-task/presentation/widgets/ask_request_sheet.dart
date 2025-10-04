import 'dart:io';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20request%20controller/operation_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AskRequestSheet extends ConsumerStatefulWidget {
  final ToDoOperationModel task;
  const AskRequestSheet({super.key, required this.task});

  @override
  ConsumerState<AskRequestSheet> createState() =>
      _OperationCompleteSheetState();
}

class _OperationCompleteSheetState extends ConsumerState<AskRequestSheet>
    with TickerProviderStateMixin {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isSubmitting = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _reasonController.dispose();

    _animationController.dispose();
    super.dispose();
  }

  bool _validateSubmission() {
    final messageState = ref.read(operationRequestControllerProvider.notifier);

    if (_reasonController.text.trim().isEmpty) {
      messageState.showMessage('Please enter the reason for delay',
          isError: true);
      return false;
    }

    return _formKey.currentState?.validate() ?? true;
  }

  Future<void> _submitTask() async {
    final messageState = ref.read(operationRequestControllerProvider.notifier);

    if (!_validateSubmission()) return;

    try {
      // Simulate API call
      if (widget.task.operationRecordId == null) {
        messageState.showMessage("operationRecordId is null!", isError: true);
        return;
      }
      final controller = ref.read(operationRequestControllerProvider.notifier);
      await controller.askRequestForReentry(
        context,
        _reasonController.text,
        widget.task.operationRecordId!,
      );
    } catch (e) {
      messageState.showMessage('Failed to submit request: ${e.toString()}',
          isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestController = ref.watch(operationRequestControllerProvider);
    final theme = Theme.of(context);
    final t = widget.task;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(theme, t),
                        const SizedBox(height: 10),

                        // Submission Section

                        _buildTextSubmission(theme),
                        if (requestController.value!.isShowingMessage)
                          // operationControllerProvider
                          Text(
                            requestController.value!.message,
                            style: AppStyle.boldStyle(
                                color: requestController.value!.isError
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        const SizedBox(height: 8),
                        // Action Buttons
                        _buildActionButtons(theme),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ToDoOperationModel task) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getSubmissionModeIcon(task.submissionType ?? SubmissionMode.text),
            color: theme.colorScheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request for Resubmit',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Request to complete this task',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextSubmission(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your reason delay',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _reasonController,
          maxLines: 2,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Reason...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.description),
            counterText: '${_reasonController.text.length}/500',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter submission text';
            }
            if (value.trim().length < 10) {
              return 'Text must be at least 10 characters';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppStyle.boldStyle(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
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
                        'Requesting...',
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
                        'Request',
                        style: AppStyle.boldStyle(),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
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
