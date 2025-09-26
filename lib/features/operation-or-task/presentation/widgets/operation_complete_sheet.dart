import 'package:camera/camera.dart';
import 'package:dazzles/features/operation-or-task/data/enums/operation_enums.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_operation_model.dart';
import 'package:dazzles/features/operation-or-task/data/model/operation_models.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class OperationCompleteSheet extends ConsumerStatefulWidget {
  final ToDoOperationModel task;
  const OperationCompleteSheet({super.key, required this.task});

  @override
  ConsumerState<OperationCompleteSheet> createState() =>
      _OperationCompleteSheetState();
}

class _OperationCompleteSheetState
    extends ConsumerState<OperationCompleteSheet> {
  final _textController = TextEditingController();
  XFile? _pickedMedia;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source) async {
    final mode = widget.task.submissionType;
    if (mode == SubmissionMode.image) {
      final f = await ImagePicker().pickImage(source: source, maxWidth: 1280);
      if (f != null) setState(() => _pickedMedia = f);
    } else if (mode == SubmissionMode.video) {
      final f = await ImagePicker()
          .pickVideo(source: source, maxDuration: const Duration(seconds: 60));
      if (f != null) setState(() => _pickedMedia = f);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(operationControllerProvider.notifier);
    final t = widget.task;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(children: [
        Text('Complete Task', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('Task: ${t.operationName}'),
        const SizedBox(height: 12),
        if (t.submissionType == SubmissionMode.text) ...[
          TextField(
              controller: _textController,
              maxLines: 4,
              decoration:
                  const InputDecoration(hintText: 'Enter submission text')),
        ] else ...[
          if (t.submissionType != null)
            Text('Submission requires ${t.submissionType!.name}'),
          const SizedBox(height: 8),
          if (t.galleryAccess == 1)
            Row(children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                onPressed: () => _pickMedia(ImageSource.gallery),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                onPressed: () => _pickMedia(ImageSource.camera),
              ),
            ])
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take from Camera'),
              onPressed: () => _pickMedia(ImageSource.camera),
            ),
          const SizedBox(height: 8),
          if (_pickedMedia != null) Text('Picked: ${_pickedMedia!.name}'),
        ],
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                // In real app: upload media / text to backend
                // Here simulate completion
                // await controller.completeOperation(t.id);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ),
        ]),
        const SizedBox(height: 8),
      ]),
    );
  }
}
