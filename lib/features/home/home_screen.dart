import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../widgets/icon_circle.dart';

/// Landing screen listing Chekkam's five pillars (Project Overview §4).
/// Only the pillars in the current build priority (SRS §2.5) are navigable;
/// the rest are honestly labeled "Coming soon" rather than faked, per the
/// Project Overview's demo-scope guidance to never overreach on scope.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconCircle(icon: Icons.check_rounded, size: 32, iconSize: 18),
            const SizedBox(width: ChekkamSpacing.sm),
            Text('Chekkam', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        children: [
          Text('One check. Total trust.', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: ChekkamSpacing.xs),
          Text(
            'Verify a suspicious message or an official document before you trust it.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ChekkamColors.muted),
          ),
          const SizedBox(height: ChekkamSpacing.xl),
          _PillarCard(
            icon: Icons.shield_outlined,
            title: 'Verify Messages & Media',
            subtitle: 'Check a suspicious text, link, or screenshot for scam risk.',
            onTap: () => context.push('/reports/new'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _PillarCard(
            icon: Icons.qr_code_scanner_rounded,
            title: 'Verify Documents',
            subtitle: 'Scan a QR code, enter an ID/PIN, or upload a file to check a signed document.',
            onTap: () => context.push('/documents/verify'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _PillarCard(
            icon: Icons.campaign_outlined,
            title: 'Public Alerts',
            subtitle: 'See human-reviewed warnings about active scams and campaigns.',
            onTap: () => context.push('/alerts'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          const _PillarCard(
            icon: Icons.extension_outlined,
            title: 'Verify Everywhere',
            subtitle: 'A browser extension for checking links where you already are.',
            comingSoon: true,
          ),
          const SizedBox(height: ChekkamSpacing.md),
          const _PillarCard(
            icon: Icons.groups_outlined,
            title: 'Protect Communities',
            subtitle: 'Moderated local safety alerts, always alongside emergency services.',
            comingSoon: true,
          ),
        ],
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.comingSoon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(ChekkamRadius.card),
        onTap: comingSoon ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(ChekkamSpacing.lg),
          child: Row(
            children: [
              IconCircle(icon: icon),
              const SizedBox(width: ChekkamSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
                        ),
                        if (comingSoon) ...[
                          const SizedBox(width: ChekkamSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ChekkamColors.tint,
                              borderRadius: BorderRadius.circular(ChekkamRadius.pill),
                            ),
                            child: Text(
                              'Next phase',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ChekkamColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: ChekkamSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ChekkamColors.muted),
                    ),
                  ],
                ),
              ),
              if (!comingSoon)
                const Icon(Icons.chevron_right_rounded, color: ChekkamColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
