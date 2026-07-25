import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../widgets/language_switch.dart';

/// FR-045: verification result is one of Genuine, Tampered, Revoked, Not Found.
class VerifyResultScreen extends StatelessWidget {
  const VerifyResultScreen({super.key, required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = result['status'] as String? ?? 'not_found';
    final config = _statusConfig(status, l10n);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(
        title: Text(l10n.verificationResult),
        actions: const [LanguageSwitch.compact()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ChekkamSpacing.xl,
            ChekkamSpacing.xl,
            ChekkamSpacing.xl,
            ChekkamSpacing.xxxl,
          ),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ChekkamColors.gradientForStatus(config.status),
                      boxShadow: [
                        ...ChekkamShadows.lg,
                        BoxShadow(
                          color: config.status.color.withValues(alpha: 0.18),
                          blurRadius: 0,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(config.icon, size: 58, color: Colors.white),
                  ),
                  const SizedBox(height: ChekkamSpacing.xl),
                  Text(
                    config.headline,
                    textAlign: TextAlign.center,
                    style: ChekkamTheme.display(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: ChekkamSpacing.sm),
                  Text(
                    config.guidance,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: ChekkamColors.muted),
                  ),
                  if (result['verification_id'] != null) ...[
                    const SizedBox(height: ChekkamSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ChekkamSpacing.lg,
                        vertical: ChekkamSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: ChekkamColors.tint,
                        borderRadius: BorderRadius.circular(ChekkamRadius.pill),
                      ),
                      child: Text(
                        '${result['verification_id']}',
                        style: ChekkamTheme.mono(
                          fontSize: 14,
                          color: ChekkamColors.ink,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (result['institution'] != null ||
                result['document_type'] != null) ...[
              const SizedBox(height: ChekkamSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(ChekkamSpacing.lg),
                decoration: BoxDecoration(
                  color: ChekkamColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(ChekkamRadius.card),
                  border: Border.all(color: ChekkamColors.border),
                  boxShadow: ChekkamShadows.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (result['institution'] != null)
                      _DetailRow(
                        label: l10n.issuedBy,
                        value: '${result['institution']}',
                      ),
                    if (result['document_type'] != null)
                      _DetailRow(
                        label: l10n.documentType,
                        value: '${result['document_type']}',
                      ),
                    if (result['reason'] != null)
                      _DetailRow(
                        label: l10n.reason,
                        value: '${result['reason']}',
                      ),
                    if (result['revoked_at'] != null)
                      _DetailRow(
                        label: l10n.revokedOn,
                        value: '${result['revoked_at']}',
                      ),
                    if (result['expiry_date'] != null)
                      _DetailRow(
                        label: l10n.expiresOn,
                        value: '${result['expiry_date']}',
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: ChekkamSpacing.xxl),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: Text(l10n.backToHome),
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(String status, AppLocalizations l10n) {
    return switch (status) {
      'genuine' => _StatusConfig(
        status: ChekkamStatus.success,
        icon: Icons.verified_rounded,
        headline: l10n.verifyHeadline(status),
        guidance: l10n.verifyGuidance(status),
      ),
      'tampered' => _StatusConfig(
        status: ChekkamStatus.danger,
        icon: Icons.gpp_bad_rounded,
        headline: l10n.verifyHeadline(status),
        guidance: l10n.verifyGuidance(status),
      ),
      'revoked' => _StatusConfig(
        status: ChekkamStatus.neutral,
        icon: Icons.block_rounded,
        headline: l10n.verifyHeadline(status),
        guidance: l10n.verifyGuidance(status),
      ),
      'expired' => _StatusConfig(
        status: ChekkamStatus.warning,
        icon: Icons.event_busy_rounded,
        headline: l10n.verifyHeadline(status),
        guidance: l10n.verifyGuidance(status),
      ),
      _ => _StatusConfig(
        status: ChekkamStatus.neutral,
        icon: Icons.help_outline_rounded,
        headline: l10n.verifyHeadline(status),
        guidance: l10n.verifyGuidance(status),
      ),
    };
  }
}

class _StatusConfig {
  _StatusConfig({
    required this.status,
    required this.icon,
    required this.headline,
    required this.guidance,
  });

  final ChekkamStatus status;
  final IconData icon;
  final String headline;
  final String guidance;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ChekkamSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.faint),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
