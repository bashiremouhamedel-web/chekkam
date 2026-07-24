import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/language_switch.dart';
import '../../widgets/permission_primer_sheet.dart';

/// Phase 2: extract text from an uploaded image or PDF via /api/ocr/upload.
/// Structurally mirrors UploadVerifyScreen (documents/upload_verify_screen.dart)
/// - same picker-then-submit flow, same inline loading/error pattern.
class OcrUploadScreen extends ConsumerStatefulWidget {
  const OcrUploadScreen({super.key});

  @override
  ConsumerState<OcrUploadScreen> createState() => _OcrUploadScreenState();
}

class _OcrUploadScreenState extends ConsumerState<OcrUploadScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _pickAndExtract() async {
    final l10n = context.l10n;
    final proceed = await PermissionPrimerSheet.show(
      context,
      icon: Icons.document_scanner_outlined,
      title: l10n.chooseFileForOcr,
      explanation: l10n.ocrPrimerExplanation,
    );
    if (!proceed) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp', 'pdf'],
      withData: true,
    );
    final picked = result?.files.single;
    final bytes = picked?.bytes;
    if (picked == null || bytes == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ocrResult = await ref
          .read(apiClientProvider)
          .uploadForOcr(fileBytes: bytes, filename: picked.name);
      if (!mounted) return;
      context.push('/ocr/result', extra: ocrResult);
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
        title: Text(l10n.extractText),
        actions: [
          IconButton(
            tooltip: l10n.ocrHistory,
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push('/ocr/history'),
          ),
          const LanguageSwitch.compact(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ocrUploadIntro,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
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
              onPressed: _loading ? null : _pickAndExtract,
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
            if (_loading) ...[
              const SizedBox(height: ChekkamSpacing.md),
              Text(
                l10n.ocrProcessing,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: ChekkamColors.faint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
