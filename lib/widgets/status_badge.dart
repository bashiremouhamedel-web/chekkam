import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Pill-shaped status badge: semantic color background at ~12% opacity,
/// full-opacity semantic color icon/text, always paired with a label — never
/// color alone (Brand Guide §3.2, §7, §8 accessibility rule).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, required this.label, this.icon});

  final ChekkamStatus status;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: ChekkamSpacing.md, vertical: ChekkamSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ChekkamRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: ChekkamSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
