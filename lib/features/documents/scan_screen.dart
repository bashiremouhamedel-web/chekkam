import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/permission_primer_sheet.dart';

/// FR-043: verify by scanning the QR code printed on a signed document.
/// Camera permission is requested only when this screen opens, preceded by
/// the SRS §7-mandated plain-language explanation, and degrades to the
/// manual-entry screen if denied rather than dead-ending the user.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _permissionRequested = false;
  bool _permissionGranted = false;
  bool _processing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestPermission());
  }

  Future<void> _requestPermission() async {
    final proceed = await PermissionPrimerSheet.show(
      context,
      icon: Icons.qr_code_scanner_rounded,
      title: 'Camera access',
      explanation:
          'Chekkam needs your camera to scan the QR code printed on the document. '
          'Nothing is recorded or uploaded — only the code is read.',
    );
    if (!mounted) return;
    if (!proceed) {
      setState(() {
        _permissionRequested = true;
        _permissionGranted = false;
      });
      return;
    }
    final granted = await ref.read(permissionsServiceProvider).requestCamera();
    if (!mounted) return;
    setState(() {
      _permissionRequested = true;
      _permissionGranted = granted;
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null) return;

    setState(() => _processing = true);
    final verificationId = _extractVerificationId(raw);

    try {
      final result = await ref.read(apiClientProvider).verifyDocumentById(verificationId);
      if (!mounted) return;
      context.push('/documents/verify/result', extra: result);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  String _extractVerificationId(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return raw;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR code')),
      body: !_permissionRequested
          ? const Center(child: CircularProgressIndicator())
          : !_permissionGranted
              ? _PermissionDenied(
                  onOpenManual: () => context.pushReplacement('/documents/verify/manual'),
                )
              : Stack(
                  children: [
                    MobileScanner(controller: _controller, onDetect: _onDetect),
                    if (_processing)
                      const ColoredBox(
                        color: Colors.black45,
                        child: Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                    if (_error != null)
                      Positioned(
                        left: ChekkamSpacing.lg,
                        right: ChekkamSpacing.lg,
                        bottom: ChekkamSpacing.xl,
                        child: Material(
                          color: ChekkamColors.danger,
                          borderRadius: BorderRadius.circular(ChekkamRadius.small),
                          child: Padding(
                            padding: const EdgeInsets.all(ChekkamSpacing.md),
                            child: Text(_error!, style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({required this.onOpenManual});

  final VoidCallback onOpenManual;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ChekkamSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography_outlined, size: 48, color: ChekkamColors.muted),
          const SizedBox(height: ChekkamSpacing.lg),
          Text(
            'Camera access was not granted',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChekkamSpacing.sm),
          Text(
            'You can still verify a document by typing its ID or PIN instead.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChekkamSpacing.lg),
          ElevatedButton(onPressed: onOpenManual, child: const Text('Enter ID or PIN instead')),
        ],
      ),
    );
  }
}
