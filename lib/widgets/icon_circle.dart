import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Chekkam's signature feature/navigation icon motif: icon inside a filled
/// Tint-colored circle (Brand Guide §5). Status icons should NOT use this —
/// they render directly in their semantic color instead.
///
/// [gradient] renders a soft brand gradient ring instead of a flat tint fill,
/// reserved for hero/seal moments (Brand Guide: "spend boldness in one place").
class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.icon,
    this.size = 48,
    this.iconSize = 24,
    this.gradient = false,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient ? null : ChekkamColors.tint,
        gradient: gradient ? ChekkamColors.gradientHero : null,
        shape: BoxShape.circle,
        boxShadow: gradient ? ChekkamShadows.sm : null,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: gradient ? ChekkamColors.white : ChekkamColors.primary,
      ),
    );
  }
}
