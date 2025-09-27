import 'dart:io';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class OperationCompleteSheet extends ConsumerStatefulWidget {
  final ToDoOperationModel task;
  const OperationCompleteSheet({super.key, required this.task});

  @override
  ConsumerState<OperationCompleteSheet> createState() =>
      _OperationCompleteSheetState();
}

class _OperationCompleteSheetState extends ConsumerState<OperationCompleteSheet>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedMedia;
  VideoPlayerController? _videoController;
  bool _isSubmitting = false;
  bool _isPreviewExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _textController.dispose();
    _videoController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source) async {
    final messageState = ref.read(operationControllerProvider.notifier);

    try {
      final mode = widget.task.submissionType;
      XFile? file;

      if (mode == SubmissionMode.image) {
        file = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
      } else if (mode == SubmissionMode.video) {
        file = await ImagePicker().pickVideo(
          source: source,
          maxDuration: const Duration(minutes: 5),
        );
      }

      if (file != null) {
        setState(() => _pickedMedia = file);

        // Initialize video controller if video is picked
        if (mode == SubmissionMode.video) {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(File(file.path));
          await _videoController!.initialize();
          setState(() {});
        }

        messageState.showMessage('Media selected successfully!',
            isError: false);
      }
    } catch (e) {
      messageState.showMessage('Failed to pick media: ${e.toString()}',
          isError: true);
    }
  }

  // bool _isShowMessage = false;
  // Color _messageColor = Colors.green;
  // String _message = '';
  // void _showMessage(String message, {bool isError = false}) {
  //   if (isError) {
  //     _messageColor = Colors.red;
  //     _message = message;
  //   } else {
  //     _messageColor = Colors.green;
  //     _message = message;
  //   }
  //   _isShowMessage = true;
  //   setState(() {});
  //   Future.delayed(const Duration(seconds: 3), () {
  //     if (mounted) {
  //       setState(() {
  //         _message = '';
  //         _isShowMessage = false;
  //       });
  //     }
  //   });
  // }

  bool _validateSubmission() {
    final messageState = ref.read(operationControllerProvider.notifier);

    final mode = widget.task.submissionType;

    if (mode == SubmissionMode.text) {
      if (_textController.text.trim().isEmpty) {
        messageState.showMessage('Please enter submission text', isError: true);
        return false;
      }
      if (_textController.text.trim().length < 10) {
        messageState.showMessage(
            'Submission text must be at least 10 characters',
            isError: true);
        return false;
      }
    } else {
      if (_pickedMedia == null) {
        messageState.showMessage(
            'Please select ${mode?.name ?? 'media'} to submit',
            isError: true);
        return false;
      }
    }

    return _formKey.currentState?.validate() ?? true;
  }

  Future<void> _submitTask() async {
    final messageState = ref.read(operationControllerProvider.notifier);

    if (!_validateSubmission()) return;

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final controller = ref.read(operationControllerProvider.notifier);
      await controller.onSubmitToDoTask(
          context,
          widget.task.operationId!.toString(),
          widget.task.assignedId.toString(),
          text:
              _textController.text.isEmpty ? null : _textController.text.trim(),
          video: widget.task.submissionType == SubmissionMode.video &&
                  _pickedMedia != null
              ? File(_pickedMedia!.path)
              : null,
          image: widget.task.submissionType == SubmissionMode.image &&
                  _pickedMedia != null
              ? File(_pickedMedia!.path)
              : null);
    } catch (e) {
      messageState.showMessage('Failed to submit task: ${e.toString()}',
          isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _removeMedia() {
    setState(() {
      _pickedMedia = null;
      _videoController?.dispose();
      _videoController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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

                        // Task Info Card
                        _buildTaskInfoCard(theme, t),
                        const SizedBox(height: 10),

                        // Submission Section
                        _buildSubmissionSection(theme, t),
                        if (ref
                            .watch(operationControllerProvider)
                            .value!
                            .isShowingMessage)
                          Text(
                            ref
                                .watch(operationControllerProvider)
                                .value!
                                .message,
                            style: AppStyle.boldStyle(
                                color: ref
                                        .watch(operationControllerProvider)
                                        .value!
                                        .isError
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
                'Complete Task',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Submit your work to complete this task',
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

  Widget _buildTaskInfoCard(ThemeData theme, ToDoOperationModel task) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.task_alt,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Task Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildInfoRow(
                'Task Name', task.operationName ?? 'Unknown', Icons.label),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Time Window',
              '${task.startTime} - ${task.endTime}',
              Icons.access_time,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Submission Type',
              task.submissionType?.name.toUpperCase() ?? 'TEXT',
              _getSubmissionModeIcon(
                  task.submissionType ?? SubmissionMode.text),
            ),
            if (task.assignedBy != null && task.assignedBy!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Assigned By', task.assignedBy!, Icons.person),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionSection(ThemeData theme, ToDoOperationModel task) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upload,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Submission',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            if (task.submissionType == SubmissionMode.text)
              _buildTextSubmission(theme)
            else
              _buildMediaSubmission(theme, task),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSubmission(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your submission text',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _textController,
          maxLines: 2,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Describe your work, progress, or results...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.description),
            counterText: '${_textController.text.length}/500',
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

  Widget _buildMediaSubmission(ThemeData theme, ToDoOperationModel task) {
    final isVideo = task.submissionType == SubmissionMode.video;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select ${isVideo ? 'video' : 'image'} to submit',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // Media Selection Buttons
        if (task.galleryAccess == 1)
          Row(
            children: [
              Expanded(
                child: _buildMediaButton(
                  'Gallery',
                  Icons.photo_library,
                  () => _pickMedia(ImageSource.gallery),
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMediaButton(
                  'Camera',
                  Icons.camera_alt,
                  () => _pickMedia(ImageSource.camera),
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          )
        else
          SizedBox(
            width: double.infinity,
            child: _buildMediaButton(
              'Take from Camera',
              Icons.camera_alt,
              () => _pickMedia(ImageSource.camera),
              theme.colorScheme.primary,
            ),
          ),

        const SizedBox(height: 16),

        // Media Preview
        if (_pickedMedia != null) _buildMediaPreview(theme, isVideo),
      ],
    );
  }

  Widget _buildMediaButton(
      String label, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(ThemeData theme, bool isVideo) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isVideo ? Icons.videocam : Icons.image,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected ${isVideo ? 'Video' : 'Image'}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _removeMedia,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _pickedMedia!.name,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Preview Section
            GestureDetector(
              onTap: () =>
                  setState(() => _isPreviewExpanded = !_isPreviewExpanded),
              child: Container(
                height: _isPreviewExpanded ? 200 : 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isVideo ? _buildVideoPreview() : _buildImagePreview(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to ${_isPreviewExpanded ? 'collapse' : 'expand'} preview',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController?.value.isInitialized ?? false) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              icon: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildImagePreview() {
    return Image.file(
      File(_pickedMedia!.path),
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.error, color: Colors.red),
        );
      },
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
                        'Submitting...',
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
                        'Submit Task',
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
