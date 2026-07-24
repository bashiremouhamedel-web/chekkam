import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../widgets/language_switch.dart';
import '../../widgets/status_badge.dart';

/// Phase 2: shows an OCR result (the evidence row returned by
/// POST /api/ocr/upload or GET /api/ocr/:id). Reuses the reasons-card layout
/// from ReportResultScreen for the extracted-text block, but with
/// SelectableText (net-new in this app) so users can copy/select manually in
/// addition to the explicit Copy button.
class OcrResultScreen extends StatelessWidget {
  const OcrResultScreen({super.key, required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = result['status'] as String?;
    final extractedText = result['ocr_text'] as String?;
    final confidence = result['confidence'] as String?;
    final config = _statusConfig(status, l10n);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(
        title: Text(l10n.ocrResult),
        actions: const [LanguageSwitch.compact()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.xl),
        children: [
          StatusBadge(
            status: config.status,
            label: config.label,
            icon: config.icon,
          ),
          const SizedBox(height: ChekkamSpacing.lg),
          Text(
            config.headline,
            style: ChekkamTheme.display(fontSize: 24, height: 1.25),
          ),
          if (status == 'done' &&
              extractedText != null &&
              extractedText.isNotEmpty) ...[
            const SizedBox(height: ChekkamSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.extractedText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: ChekkamColors.faint,
                  ),
                ),
                if (confidence != null)
                  Text(
                    l10n.confidenceLabel(confidence),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ChekkamColors.muted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: ChekkamSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ChekkamSpacing.lg),
              decoration: BoxDecoration(
                color: ChekkamColors.surfaceRaised,
                borderRadius: BorderRadius.circular(ChekkamRadius.card),
                border: Border.all(color: ChekkamColors.border),
                boxShadow: ChekkamShadows.sm,
              ),
              child: SelectableText(
                extractedText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: ChekkamSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(context, extractedText),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(l10n.copyText),
                  ),
                ),
                const SizedBox(width: ChekkamSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(text: extractedText),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(l10n.shareText),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: ChekkamSpacing.xl),
          Container(
            padding: const EdgeInsets.all(ChekkamSpacing.lg),
            decoration: BoxDecoration(
              color: ChekkamColors.tint,
              borderRadius: BorderRadius.circular(ChekkamRadius.card),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: ChekkamColors.primary,
                ),
                const SizedBox(width: ChekkamSpacing.md),
                Expanded(
                  child: Text(
                    config.guidance,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ChekkamSpacing.xl),
          OutlinedButton(
            onPressed: () => context.go('/'),
            child: Text(l10n.backToHome),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final l10n = context.l10n;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
  }

  _OcrStatusConfig _statusConfig(String? status, AppLocalizations l10n) {
    return switch (status) {
      'done' => _OcrStatusConfig(
        status: ChekkamStatus.success,
        label: l10n.ocrStatusDone,
        icon: Icons.text_snippet_outlined,
        headline: l10n.ocrDoneHeadline,
        guidance: l10n.ocrDoneGuidance,
      ),
      'unavailable' => _OcrStatusConfig(
        status: ChekkamStatus.neutral,
        label: l10n.ocrStatusUnavailable,
        icon: Icons.cloud_off_rounded,
        headline: l10n.ocrUnavailableHeadline,
        guidance: l10n.ocrUnavailableGuidance,
      ),
      _ => _OcrStatusConfig(
        status: ChekkamStatus.danger,
        label: l10n.ocrStatusFailed,
        icon: Icons.error_outline_rounded,
        headline: l10n.ocrFailedHeadline,
        guidance: l10n.ocrFailedGuidance,
      ),
    };
  }
}

class _OcrStatusConfig {
  _OcrStatusConfig({
    required this.status,
    required this.label,
    required this.icon,
    required this.headline,
    required this.guidance,
  });

  final ChekkamStatus status;
  final String label;
  final IconData icon;
  final String headline;
  final String guidance;
}
