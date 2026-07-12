import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../services/providers.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/language_switch.dart';

/// Latest published alert for the home screen's "what's happening" strip.
/// Fails silently to null (no backend configured, offline, etc.) — the home
/// screen must never break just because this optional preview couldn't load.
final _latestAlertProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final body = await ref.watch(apiClientProvider).listPublicAlerts();
    final alerts = (body['alerts'] as List?) ?? const [];
    return alerts.isEmpty ? null : alerts.first as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
});

/// Home screen, redesigned intent-first (Brand Guide v2): one prominent
/// "paste to check" action for the single most common task, instead of a
/// flat list of five equally-weighted pillar cards. Document verification
/// and safety alerts follow as secondary tiles.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final latestAlert = ref.watch(_latestAlertProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.goodMorning
        : (hour < 18 ? l10n.goodAfternoon : l10n.goodEvening);

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ChekkamSpacing.xl,
            ChekkamSpacing.lg,
            ChekkamSpacing.xl,
            ChekkamSpacing.xxxl,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ChekkamColors.faint,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Chekkam', style: ChekkamTheme.display(fontSize: 26)),
                  ],
                ),
                const Row(
                  children: [
                    LanguageSwitch.compact(),
                    IconCircle(icon: Icons.check_rounded, gradient: true),
                  ],
                ),
              ],
            ),
            const SizedBox(height: ChekkamSpacing.xl),

            // Primary intent: check a message. This is the single most
            // common task, so it gets the most visual weight on the page.
            _PasteToCheckCard(onTap: () => context.push('/reports/new')),

            const SizedBox(height: ChekkamSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: Icons.qr_code_scanner_rounded,
                    title: l10n.verifyDocument,
                    subtitle: l10n.scanPinOrUpload,
                    onTap: () => context.push('/documents/verify'),
                  ),
                ),
                const SizedBox(width: ChekkamSpacing.md),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.shield_moon_outlined,
                    title: l10n.publicAlerts,
                    subtitle: l10n.reviewedWarnings,
                    onTap: () => context.push('/alerts'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: ChekkamSpacing.xl),
            Text(
              l10n.comingSoon,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: ChekkamColors.faint,
              ),
            ),
            const SizedBox(height: ChekkamSpacing.md),
            _ComingSoonRow(
              icon: Icons.extension_outlined,
              title: l10n.verifyEverywhere,
              subtitle: l10n.verifyEverywhereSubtitle,
            ),
            const SizedBox(height: ChekkamSpacing.sm),
            _ComingSoonRow(
              icon: Icons.groups_outlined,
              title: l10n.protectCommunities,
              subtitle: l10n.protectCommunitiesSubtitle,
            ),

            latestAlert.when(
              data: (alert) => alert == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: ChekkamSpacing.xl),
                      child: _LatestAlertStrip(
                        title: '${alert['title']}',
                        body: '${alert['body']}',
                        onTap: () => context.push('/alerts'),
                      ),
                    ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasteToCheckCard extends StatelessWidget {
  const _PasteToCheckCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ChekkamRadius.hero),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(ChekkamSpacing.xl),
          decoration: BoxDecoration(
            gradient: ChekkamColors.gradientHero,
            borderRadius: BorderRadius.circular(ChekkamRadius.hero),
            boxShadow: ChekkamShadows.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.gotSomethingSuspicious,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ChekkamColors.brightRed,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: ChekkamSpacing.sm),
              Text(
                l10n.pasteSuspicious,
                style: ChekkamTheme.display(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: ChekkamSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChekkamSpacing.lg,
                  vertical: ChekkamSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(ChekkamRadius.small),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.pasteToCheck,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChekkamColors.surfaceRaised,
      borderRadius: BorderRadius.circular(ChekkamRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(ChekkamRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(ChekkamSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ChekkamRadius.card),
            border: Border.all(color: ChekkamColors.border),
            boxShadow: ChekkamShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconCircle(icon: icon, size: 42, iconSize: 20),
              const SizedBox(height: ChekkamSpacing.md),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: ChekkamColors.faint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoonRow extends StatelessWidget {
  const _ComingSoonRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(ChekkamSpacing.md),
      decoration: BoxDecoration(
        color: ChekkamColors.tint,
        borderRadius: BorderRadius.circular(ChekkamRadius.small),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ChekkamColors.faint),
          const SizedBox(width: ChekkamSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ChekkamColors.faint),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ChekkamColors.surfaceRaised,
              borderRadius: BorderRadius.circular(ChekkamRadius.pill),
            ),
            child: Text(
              l10n.nextPhase,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ChekkamColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestAlertStrip extends StatelessWidget {
  const _LatestAlertStrip({
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChekkamColors.surfaceRaised,
      borderRadius: BorderRadius.circular(ChekkamRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(ChekkamRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(ChekkamSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ChekkamRadius.card),
            border: Border.all(color: ChekkamColors.border),
            boxShadow: ChekkamShadows.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.campaign_rounded,
                size: 20,
                color: ChekkamColors.warning,
              ),
              const SizedBox(width: ChekkamSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ChekkamColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
