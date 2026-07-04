import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Chekkam's signature feature/navigation icon motif: icon inside a filled
/// Tint-colored circle (Brand Guide §5). Status icons should NOT use this —
/// they render directly in their semantic color instead.
class IconCircle extends StatelessWidget {
  const IconCircle({super.key, required this.icon, this.size = 48, this.iconSize = 24});

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: ChekkamColors.tint, shape: BoxShape.circle),
      child: Icon(icon, size: iconSize, color: ChekkamColors.primary),
    );
  }
}
