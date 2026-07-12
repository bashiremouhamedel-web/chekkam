import 'package:flutter/material.dart';

import '../app/localization.dart';
import '../app/theme.dart';
import 'icon_circle.dart';

/// SRS Section 7: every sensitive permission request must be preceded by a
/// short, plain-language explanation shown in the app's own UI, before the
/// OS dialog appears. Call [show] and only proceed to the actual
/// permission_handler request if the user taps "Continue."
class PermissionPrimerSheet {
  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String explanation,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ChekkamRadius.card),
        ),
      ),
      builder: (context) {
        final l10n = context.l10n;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            ChekkamSpacing.xl,
            ChekkamSpacing.xl,
            ChekkamSpacing.xl,
            ChekkamSpacing.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconCircle(icon: icon),
              const SizedBox(height: ChekkamSpacing.lg),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: ChekkamSpacing.sm),
              Text(explanation, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: ChekkamSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l10n.notNow),
                    ),
                  ),
                  const SizedBox(width: ChekkamSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.continueAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }
}
