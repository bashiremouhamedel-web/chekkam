import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';

class ManualVerifyScreen extends ConsumerStatefulWidget {
  const ManualVerifyScreen({super.key});

  @override
  ConsumerState<ManualVerifyScreen> createState() => _ManualVerifyScreenState();
}

class _ManualVerifyScreenState extends ConsumerState<ManualVerifyScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Enter a verification ID or PIN.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await ref.read(apiClientProvider).verifyDocumentById(value);
      if (!mounted) return;
      context.push('/documents/verify/result', extra: result);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter ID or PIN')),
      body: Padding(
        padding: const EdgeInsets.all(ChekkamSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type the verification ID (e.g. CHK-4F7K-9QRT) or the 6-digit PIN printed on the document.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            ),
            const SizedBox(height: ChekkamSpacing.lg),
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              style: ChekkamTheme.mono(fontSize: 16, color: ChekkamColors.ink),
              decoration: InputDecoration(
                hintText: 'CHK-4F7K-9QRT or 482915',
                hintStyle: ChekkamTheme.mono(fontSize: 16, color: ChekkamColors.faint),
              ),
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: ChekkamSpacing.sm),
              Text(_error!, style: const TextStyle(color: ChekkamColors.danger)),
            ],
            const SizedBox(height: ChekkamSpacing.xl),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
