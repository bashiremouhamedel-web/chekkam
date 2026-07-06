import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/permission_primer_sheet.dart';

/// FR-043: verify by uploading a photo/file of the document — works even for
/// a photocopy or forwarded scan, since the backend falls back to a file-hash
/// lookup search when hashes don't match an exact record. An optional
/// verification ID lets the backend do a hash *comparison* against a known
/// document instead of a hash-only search, which is what surfaces "Tampered"
/// rather than "Not Found" for an altered copy.
///
/// Note: we intentionally don't also call permission_handler's photo-library
/// permission here. image_picker uses the OS's modern system picker
/// (PHPickerViewController on iOS, the Android 13+ photo picker), which reads
/// only the selected file and needs no broad library permission — requesting
/// one anyway would trigger a needless, more invasive prompt.
class UploadVerifyScreen extends ConsumerStatefulWidget {
  const UploadVerifyScreen({super.key});

  @override
  ConsumerState<UploadVerifyScreen> createState() => _UploadVerifyScreenState();
}

class _UploadVerifyScreenState extends ConsumerState<UploadVerifyScreen> {
  final _verificationIdController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _verificationIdController.dispose();
    super.dispose();
  }

  Future<void> _pickAndVerify() async {
    final proceed = await PermissionPrimerSheet.show(
      context,
      icon: Icons.upload_file_rounded,
      title: 'Choose a file to check',
      explanation:
          'Pick a photo or file of the document. Only that one file is sent to Chekkam for verification.',
    );
    if (!proceed) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // XFile.readAsBytes() works on every platform, including web (where
      // picked.path is a blob: URL, not a real filesystem path — dart:io's
      // File() cannot read it).
      final bytes = await picked.readAsBytes();
      final verificationId = _verificationIdController.text.trim();
      final result = await ref.read(apiClientProvider).verifyDocumentUpload(
            fileBytes: bytes,
            filename: picked.name,
            verificationId: verificationId.isEmpty ? null : verificationId,
          );
      if (!mounted) return;
      context.push('/documents/verify/result', extra: result);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload a document')),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a photo or file of the document. Chekkam compares it against the signed original.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            TextField(
              controller: _verificationIdController,
              decoration: const InputDecoration(
                labelText: 'Verification ID (optional, if known)',
                hintText: 'CHK-4F7K-9QRT or 482915',
              ),
            ),
            const SizedBox(height: ChekkamSpacing.xl),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: ChekkamColors.danger)),
              const SizedBox(height: ChekkamSpacing.md),
            ],
            ElevatedButton(
              onPressed: _loading ? null : _pickAndVerify,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Choose file'),
            ),
          ],
        ),
      ),
    );
  }
}
