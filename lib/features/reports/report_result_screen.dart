import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../widgets/status_badge.dart';

/// FR-012/FR-024: shows the AI risk result, always labeled as advisory and
/// pending human review — never a final verdict (SRS §13 cautious language).
class ReportResultScreen extends StatelessWidget {
  const ReportResultScreen({super.key, required this.report});

  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final riskLevel = report['risk_level'] as String?;
    final reasons = (report['ai_reasons'] as List?)?.cast<String>() ?? const [];
    final recommendedAction = report['recommended_action'] as String?;
    final config = _riskConfig(riskLevel);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(title: const Text('Analysis result')),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.xl),
        children: [
          if (config != null)
            StatusBadge(status: config.status, label: config.label, icon: Icons.shield_outlined)
          else
            const StatusBadge(
              status: ChekkamStatus.neutral,
              label: 'Pending review',
              icon: Icons.hourglass_empty_rounded,
            ),
          const SizedBox(height: ChekkamSpacing.lg),
          Text(
            recommendedAction ?? 'This report is queued for review — check back shortly.',
            style: ChekkamTheme.display(fontSize: 24, height: 1.25),
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: ChekkamSpacing.xl),
            Text(
              'WHY WE THINK THIS',
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
                      padding: EdgeInsets.only(bottom: reason == reasons.last ? 0 : ChekkamSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 6, color: ChekkamColors.faint),
                          const SizedBox(width: ChekkamSpacing.sm),
                          Expanded(child: Text(reason, style: Theme.of(context).textTheme.bodyMedium)),
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
                const Icon(Icons.info_outline_rounded, color: ChekkamColors.primary),
                const SizedBox(width: ChekkamSpacing.md),
                Expanded(
                  child: Text(
                    'This is an automated first look. A Chekkam analyst reviews every report before any '
                    'final action is taken.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ChekkamSpacing.xl),
          OutlinedButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to home'),
          ),
        ],
      ),
    );
  }

  _RiskConfig? _riskConfig(String? level) {
    return switch (level) {
      'low' => _RiskConfig(status: ChekkamStatus.success, label: 'Low risk'),
      'medium' => _RiskConfig(status: ChekkamStatus.warning, label: 'Medium risk'),
      'high' => _RiskConfig(status: ChekkamStatus.danger, label: 'High risk'),
      'critical' => _RiskConfig(status: ChekkamStatus.danger, label: 'Critical risk'),
      _ => null,
    };
  }
}

class _RiskConfig {
  _RiskConfig({required this.status, required this.label});

  final ChekkamStatus status;
  final String label;
}
