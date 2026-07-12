import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/language_switch.dart';
import '../../widgets/permission_primer_sheet.dart';

/// FR-043: verify by uploading a photo/file of the document.
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
    final l10n = context.l10n;
    final proceed = await PermissionPrimerSheet.show(
      context,
      icon: Icons.upload_file_rounded,
      title: l10n.chooseFileToCheck,
      explanation: l10n.uploadPrimerExplanation,
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
      final bytes = await picked.readAsBytes();
      final verificationId = _verificationIdController.text.trim();
      final result = await ref
          .read(apiClientProvider)
          .verifyDocumentUpload(
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadDocument),
        actions: const [LanguageSwitch.compact()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.uploadVerifyIntro,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            TextField(
              controller: _verificationIdController,
              decoration: InputDecoration(
                labelText: l10n.verificationIdOptional,
                hintText: 'CHK-4F7K-9QRT or 482915',
              ),
            ),
            const SizedBox(height: ChekkamSpacing.xl),
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: ChekkamColors.danger),
              ),
              const SizedBox(height: ChekkamSpacing.md),
            ],
            ElevatedButton(
              onPressed: _loading ? null : _pickAndVerify,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.chooseFile),
            ),
          ],
        ),
      ),
    );
  }
}
