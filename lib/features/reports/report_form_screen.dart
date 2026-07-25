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

/// FR-010/FR-011/FR-012: submit suspicious text/link content and show the AI
/// risk result once analysis completes. Image content is OCR'd first
/// (POST /api/ocr/upload), then the extracted text runs through the exact
/// same analysis path as pasted text (Phase 3: OCR -> risk analysis, chaining
/// the two engines rather than a third).
class ReportFormScreen extends ConsumerStatefulWidget {
  const ReportFormScreen({super.key});

  @override
  ConsumerState<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends ConsumerState<ReportFormScreen> {
  final _controller = TextEditingController();
  String _contentType = 'text';
  bool _loading = false;
  String? _error;
  PlatformFile? _pickedFile;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
    if (picked?.bytes == null) return;
    setState(() {
      _pickedFile = picked;
      _error = null;
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_contentType == 'image') {
      await _submitImage();
      return;
    }

    final content = _controller.text.trim();
    if (content.isEmpty) {
      setState(() => _error = l10n.pasteOrTypeFirst);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final submitted = await api.submitReport(
        contentType: _contentType,
        rawContent: content,
      );
      final reportId = submitted['id'] as String;
      final report = await api.getReport(reportId);
      if (!mounted) return;
      context.push('/reports/result', extra: report);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitImage() async {
    final l10n = context.l10n;
    final file = _pickedFile;
    if (file?.bytes == null) {
      setState(() => _error = l10n.chooseFileForOcr);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final ocrResult = await api.uploadForOcr(
        fileBytes: file!.bytes!,
        filename: file.name,
      );

      if (ocrResult['status'] != 'done') {
        setState(() => _error = l10n.ocrUnavailableGuidance);
        return;
      }

      final extractedText = ocrResult['ocr_text'] as String? ?? '';
      if (extractedText.trim().isEmpty) {
        setState(() => _error = l10n.ocrNoTextFound);
        return;
      }

      final submitted = await api.submitReport(
        contentType: 'text',
        rawContent: extractedText,
        evidenceId: ocrResult['id'] as String?,
      );
      final reportId = submitted['id'] as String;
      final report = await api.getReport(reportId);
      if (!mounted) return;
      context.push('/reports/result', extra: report);
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
        title: Text(l10n.checkMessage),
        actions: const [LanguageSwitch.compact()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportIntro,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'text', label: Text(l10n.text)),
                ButtonSegment(value: 'link', label: Text(l10n.link)),
                ButtonSegment(
                  value: 'image',
                  label: Text(l10n.extractText),
                ),
              ],
              selected: {_contentType},
              onSelectionChanged: (selection) => setState(() {
                _contentType = selection.first;
                _error = null;
              }),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            if (_contentType == 'image')
              OutlinedButton.icon(
                onPressed: _loading ? null : _pickImage,
                icon: const Icon(Icons.image_outlined, size: 18),
                label: Text(
                  _pickedFile == null
                      ? l10n.chooseFileForOcr
                      : _pickedFile!.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              TextField(
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: _contentType == 'link'
                      ? 'https://example.com/suspicious-link'
                      : l10n.pasteMessageHint,
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: ChekkamSpacing.sm),
              Text(
                _error!,
                style: const TextStyle(color: ChekkamColors.danger),
              ),
            ],
            const SizedBox(height: ChekkamSpacing.xl),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.analyze),
            ),
          ],
        ),
      ),
    );
  }
}
