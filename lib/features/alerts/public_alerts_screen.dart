import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';

/// FR-090: human-approved public alerts, visible without an account.
class PublicAlertsScreen extends ConsumerStatefulWidget {
  const PublicAlertsScreen({super.key});

  @override
  ConsumerState<PublicAlertsScreen> createState() => _PublicAlertsScreenState();
}

class _PublicAlertsScreenState extends ConsumerState<PublicAlertsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final body = await ref.read(apiClientProvider).listPublicAlerts();
    return (body['alerts'] as List? ?? const []).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Public alerts')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final message =
                snapshot.error is ApiException ? (snapshot.error as ApiException).message : 'Something went wrong.';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ChekkamSpacing.xl),
                child: Text(message, textAlign: TextAlign.center),
              ),
            );
          }
          final alerts = snapshot.data ?? const [];
          if (alerts.isEmpty) {
            return Center(
              child: Text(
                'No active alerts right now.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(ChekkamSpacing.lg),
            itemCount: alerts.length,
            separatorBuilder: (_, _) => const SizedBox(height: ChekkamSpacing.md),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(ChekkamSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${alert['title']}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: ChekkamSpacing.sm),
                      Text('${alert['body']}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
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
