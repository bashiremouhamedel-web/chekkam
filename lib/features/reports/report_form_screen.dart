import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';

/// FR-010/FR-011/FR-012: submit suspicious text/link content and show the AI
/// risk result once analysis completes. Image/file submission (from the
/// share-sheet or a photo) is a separate, later flow — see SRS FR-048 (OCR)
/// as a documented next step.
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      setState(() => _error = 'Paste or type the suspicious content first.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final submitted = await api.submitReport(contentType: _contentType, rawContent: content);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Check a message')),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste a suspicious message or link. Chekkam will analyze it for scam risk — '
              'this never means you did anything wrong by receiving it.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'text', label: Text('Text')),
                ButtonSegment(value: 'link', label: Text('Link')),
              ],
              selected: {_contentType},
              onSelectionChanged: (selection) => setState(() => _contentType = selection.first),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: _contentType == 'link'
                    ? 'https://example.com/suspicious-link'
                    : 'Paste the message here...',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: ChekkamSpacing.sm),
              Text(_error!, style: const TextStyle(color: ChekkamColors.danger)),
            ],
            const SizedBox(height: ChekkamSpacing.xl),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
