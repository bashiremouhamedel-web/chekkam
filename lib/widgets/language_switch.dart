import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/locale_controller.dart';
import '../app/localization.dart';
import '../app/theme.dart';

class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key, this.compact = false});

  const LanguageSwitch.compact({super.key}) : compact = true;

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final l10n = context.l10n;

    return Semantics(
      label: l10n.languageSwitcherLabel,
      child: Padding(
        padding: EdgeInsets.only(right: compact ? ChekkamSpacing.sm : 0),
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? ChekkamSpacing.sm : ChekkamSpacing.md,
              vertical: 0,
            ),
            visualDensity: VisualDensity.compact,
            textStyle: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          segments: [
            ButtonSegment(
              value: 'en',
              label: const Text('EN'),
              tooltip: l10n.languageEnglish,
            ),
            ButtonSegment(
              value: 'fr',
              label: const Text('FR'),
              tooltip: l10n.languageFrench,
            ),
          ],
          selected: {locale.languageCode == 'fr' ? 'fr' : 'en'},
          onSelectionChanged: (selection) {
            ref.read(appLocaleProvider.notifier).setLanguage(selection.first);
          },
        ),
      ),
    );
  }
}
