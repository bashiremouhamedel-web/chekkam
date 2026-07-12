import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../widgets/icon_circle.dart';
import '../../widgets/language_switch.dart';

/// Entry point for document verification (FR-043): scan, manual ID/PIN entry,
/// or file upload.
class VerifyHubScreen extends StatelessWidget {
  const VerifyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(
        title: Text(l10n.verifyDocument),
        actions: const [LanguageSwitch.compact()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.xl),
        children: [
          Text(
            l10n.verifyHubIntro,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
          ),
          const SizedBox(height: ChekkamSpacing.xl),
          _Option(
            icon: Icons.qr_code_scanner_rounded,
            title: l10n.scanQrCode,
            subtitle: l10n.scanQrSubtitle,
            onTap: () => context.push('/documents/verify/scan'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _Option(
            icon: Icons.dialpad_rounded,
            title: l10n.enterIdOrPin,
            subtitle: l10n.enterIdSubtitle,
            onTap: () => context.push('/documents/verify/manual'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _Option(
            icon: Icons.upload_file_rounded,
            title: l10n.uploadPhotoOrFile,
            subtitle: l10n.uploadPhotoSubtitle,
            onTap: () => context.push('/documents/verify/upload'),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
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
          child: Row(
            children: [
              IconCircle(icon: icon),
              const SizedBox(width: ChekkamSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: ChekkamSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ChekkamColors.faint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: ChekkamSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: ChekkamColors.faint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
