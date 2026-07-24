import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/language_switch.dart';

/// Phase 2: GET /api/ocr/history — structurally identical to
/// PublicAlertsScreen's FutureBuilder + ListView.separated pattern.
/// Requires auth (see docs/api/ocr.md) — an ApiException here is most often
/// a 401, rendered the same as any other fetch error.
class OcrHistoryScreen extends ConsumerStatefulWidget {
  const OcrHistoryScreen({super.key});

  @override
  ConsumerState<OcrHistoryScreen> createState() => _OcrHistoryScreenState();
}

class _OcrHistoryScreenState extends ConsumerState<OcrHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final body = await ref.read(apiClientProvider).getOcrHistory();
    return (body['ocr_results'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: ChekkamColors.surface,
      appBar: AppBar(
        title: Text(l10n.ocrHistory),
        actions: const [LanguageSwitch.compact()],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : l10n.somethingWentWrong;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ChekkamSpacing.xl),
                child: Text(message, textAlign: TextAlign.center),
              ),
            );
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                l10n.noOcrHistory,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(ChekkamSpacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: ChekkamSpacing.md),
            itemBuilder: (context, index) {
              final item = items[index];
              final status = '${item['status'] ?? 'done'}';
              final statusColor = switch (status) {
                'done' => ChekkamColors.primary,
                'unavailable' => ChekkamColors.faint,
                _ => ChekkamColors.danger,
              };
              final preview = '${item['ocr_text'] ?? ''}';
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(ChekkamRadius.card),
                  onTap: () => context.push('/ocr/result', extra: item),
                  child: Padding(
                    padding: const EdgeInsets.all(ChekkamSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.text_snippet_outlined,
                          color: statusColor,
                          size: 22,
                        ),
                        const SizedBox(width: ChekkamSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.ocrStatusForHistory(status),
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontSize: 15),
                              ),
                              if (preview.isNotEmpty) ...[
                                const SizedBox(height: ChekkamSpacing.sm),
                                Text(
                                  preview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: ChekkamColors.muted),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
