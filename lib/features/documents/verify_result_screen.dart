import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../widgets/status_badge.dart';

/// FR-045: verification result is exactly one of Genuine, Tampered, Revoked,
/// Not Found. Copy stays calm and action-oriented per the brand voice —
/// never alarmist, even for Tampered (SRS §13: cautious status language).
class VerifyResultScreen extends StatelessWidget {
  const VerifyResultScreen({super.key, required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final status = result['status'] as String? ?? 'not_found';
    final config = _statusConfig(status);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification result')),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(status: config.status, label: config.label, icon: config.icon),
            const SizedBox(height: ChekkamSpacing.lg),
            Text(config.headline, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: ChekkamSpacing.sm),
            Text(
              config.guidance,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ChekkamColors.muted),
            ),
            if (result['institution'] != null || result['document_type'] != null) ...[
              const SizedBox(height: ChekkamSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(ChekkamSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result['institution'] != null)
                        _DetailRow(label: 'Issued by', value: '${result['institution']}'),
                      if (result['document_type'] != null)
                        _DetailRow(label: 'Document type', value: '${result['document_type']}'),
                      if (result['verification_id'] != null)
                        _DetailRow(label: 'Verification ID', value: '${result['verification_id']}'),
                      if (result['reason'] != null)
                        _DetailRow(label: 'Reason', value: '${result['reason']}'),
                    ],
                  ),
                ),
              ),
            ],
            const Spacer(),
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
          label: 'Genuine',
          icon: Icons.verified_rounded,
          headline: 'This document is genuine',
          guidance: 'Its signature matches the issuing institution\'s records and has not been revoked.',
        ),
      'tampered' => _StatusConfig(
          status: ChekkamStatus.danger,
          label: 'Tampered',
          icon: Icons.gpp_bad_rounded,
          headline: 'This document does not match the original',
          guidance:
              'The content does not match what was signed. Contact the issuing institution before relying on it.',
        ),
      'revoked' => _StatusConfig(
          status: ChekkamStatus.neutral,
          label: 'Revoked',
          icon: Icons.block_rounded,
          headline: 'This document has been revoked',
          guidance: 'The issuing institution withdrew this document. See the reason below if provided.',
        ),
      _ => _StatusConfig(
          status: ChekkamStatus.neutral,
          label: 'Not Found',
          icon: Icons.help_outline_rounded,
          headline: 'No matching document found',
          guidance:
              'Double-check the ID or PIN, or try scanning the QR code again. Contact the issuing institution if you believe this is a mistake.',
        ),
    };
  }
}

class _StatusConfig {
  _StatusConfig({
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
