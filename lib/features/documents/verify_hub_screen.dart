import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../widgets/icon_circle.dart';

/// Entry point for document verification (FR-043): scan, manual ID/PIN entry,
/// or file upload. Offering all three up front means a denied camera
/// permission never blocks verification outright (SRS §7 "degrade gracefully").
class VerifyHubScreen extends StatelessWidget {
  const VerifyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify a document')),
      body: ListView(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        children: [
          Text(
            'Check whether a certificate, letter, or other official document is genuine.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
          ),
          const SizedBox(height: ChekkamSpacing.xl),
          _Option(
            icon: Icons.qr_code_scanner_rounded,
            title: 'Scan QR code',
            subtitle: 'Use the camera to scan the code printed on the document.',
            onTap: () => context.push('/documents/verify/scan'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _Option(
            icon: Icons.dialpad_rounded,
            title: 'Enter ID or PIN',
            subtitle: 'Type the verification ID or PIN shown on the document.',
            onTap: () => context.push('/documents/verify/manual'),
          ),
          const SizedBox(height: ChekkamSpacing.md),
          _Option(
            icon: Icons.upload_file_rounded,
            title: 'Upload a photo or file',
            subtitle: 'Works even for a photocopy or forwarded scan.',
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
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(ChekkamRadius.card),
        onTap: onTap,
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
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
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
              const Icon(Icons.chevron_right_rounded, color: ChekkamColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
