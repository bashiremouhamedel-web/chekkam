import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';

/// FR-045: verification result is exactly one of Genuine, Tampered, Revoked,
/// Not Found. Redesigned as a single "seal moment" (Brand Guide v2) — one
/// focal badge, one verdict word, nothing else competing for attention in a
/// high-stakes moment. Copy stays calm and action-oriented per the brand
/// voice — never alarmist, even for Tampered (SRS §13: cautious language).
class VerifyResultScreen extends StatelessWidget {
  const VerifyResultScreen({super.key, required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final status = result['status'] as String? ?? 'not_found';
    final config = _statusConfig(status);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(title: const Text('Verification result')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(ChekkamSpacing.xl, ChekkamSpacing.xl, ChekkamSpacing.xl, ChekkamSpacing.xxxl),
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
                        BoxShadow(color: config.status.color.withValues(alpha: 0.18), blurRadius: 0, spreadRadius: 8),
                      ],
                    ),
                    child: Icon(config.icon, size: 58, color: Colors.white),
                  ),
                  const SizedBox(height: ChekkamSpacing.xl),
                  Text(
                    config.headline,
                    textAlign: TextAlign.center,
                    style: ChekkamTheme.display(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: ChekkamSpacing.sm),
                  Text(
                    config.guidance,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ChekkamColors.muted),
                  ),
                  if (result['verification_id'] != null) ...[
                    const SizedBox(height: ChekkamSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: ChekkamSpacing.lg, vertical: ChekkamSpacing.sm),
                      decoration: BoxDecoration(
                        color: ChekkamColors.tint,
                        borderRadius: BorderRadius.circular(ChekkamRadius.pill),
                      ),
                      child: Text(
                        '${result['verification_id']}',
                        style: ChekkamTheme.mono(fontSize: 14, color: ChekkamColors.ink),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (result['institution'] != null || result['document_type'] != null) ...[
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
                      _DetailRow(label: 'Issued by', value: '${result['institution']}'),
                    if (result['document_type'] != null)
                      _DetailRow(label: 'Document type', value: '${result['document_type']}'),
                    if (result['reason'] != null)
                      _DetailRow(label: 'Reason', value: '${result['reason']}'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: ChekkamSpacing.xxl),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    return switch (status) {
      'genuine' => _StatusConfig(
          status: ChekkamStatus.success,
          icon: Icons.verified_rounded,
          headline: 'Genuine.',
          guidance: 'Its signature matches the issuing institution\'s records and has not been revoked.',
        ),
      'tampered' => _StatusConfig(
          status: ChekkamStatus.danger,
          icon: Icons.gpp_bad_rounded,
          headline: 'Tampered.',
          guidance:
              'The content does not match what was signed. Contact the issuing institution before relying on it.',
        ),
      'revoked' => _StatusConfig(
          status: ChekkamStatus.neutral,
          icon: Icons.block_rounded,
          headline: 'Revoked.',
          guidance: 'The issuing institution withdrew this document. See the reason below if provided.',
        ),
      _ => _StatusConfig(
          status: ChekkamStatus.neutral,
          icon: Icons.help_outline_rounded,
          headline: 'Not found.',
          guidance:
              'Double-check the ID or PIN, or try scanning the QR code again. Contact the issuing institution if you believe this is a mistake.',
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.faint),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
