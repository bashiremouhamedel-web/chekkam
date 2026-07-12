import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../widgets/language_switch.dart';
import '../../widgets/status_badge.dart';

/// FR-012/FR-024: shows the AI risk result, always labeled as advisory and
/// pending human review, never a final verdict.
class ReportResultScreen extends StatelessWidget {
  const ReportResultScreen({super.key, required this.report});

  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final riskLevel = report['risk_level'] as String?;
    final reasons = (report['ai_reasons'] as List?)?.cast<String>() ?? const [];
    final recommendedAction = report['recommended_action'] as String?;
    final config = _riskConfig(riskLevel, l10n);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(
        title: Text(l10n.analysisResult),
        actions: const [LanguageSwitch.compact()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.xl),
        children: [
          if (config != null)
            StatusBadge(
              status: config.status,
              label: config.label,
              icon: Icons.shield_outlined,
            )
          else
            StatusBadge(
              status: ChekkamStatus.neutral,
              label: l10n.pendingReview,
              icon: Icons.hourglass_empty_rounded,
            ),
          const SizedBox(height: ChekkamSpacing.lg),
          Text(
            recommendedAction ?? l10n.reportQueued,
            style: ChekkamTheme.display(fontSize: 24, height: 1.25),
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: ChekkamSpacing.xl),
            Text(
              l10n.whyWeThinkThis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: ChekkamColors.faint,
              ),
            ),
            const SizedBox(height: ChekkamSpacing.sm),
            Container(
              padding: const EdgeInsets.all(ChekkamSpacing.lg),
              decoration: BoxDecoration(
                color: ChekkamColors.surfaceRaised,
                borderRadius: BorderRadius.circular(ChekkamRadius.card),
                border: Border.all(color: ChekkamColors.border),
                boxShadow: ChekkamShadows.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final reason in reasons)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: reason == reasons.last ? 0 : ChekkamSpacing.sm,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: ChekkamColors.faint,
                          ),
                          const SizedBox(width: ChekkamSpacing.sm),
                          Expanded(
                            child: Text(
                              reason,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
                    l10n.automatedFirstLook,
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

  _RiskConfig? _riskConfig(String? level, AppLocalizations l10n) {
    return switch (level) {
      'low' => _RiskConfig(
        status: ChekkamStatus.success,
        label: l10n.riskLabel(level),
      ),
      'medium' => _RiskConfig(
        status: ChekkamStatus.warning,
        label: l10n.riskLabel(level),
      ),
      'high' => _RiskConfig(
        status: ChekkamStatus.danger,
        label: l10n.riskLabel(level),
      ),
      'critical' => _RiskConfig(
        status: ChekkamStatus.danger,
        label: l10n.riskLabel(level),
      ),
      _ => null,
    };
  }
}

class _RiskConfig {
  _RiskConfig({required this.status, required this.label});

  final ChekkamStatus status;
  final String label;
}
