import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../services/api_client.dart';
import '../../services/providers.dart';
import '../../widgets/language_switch.dart';
import '../../widgets/permission_primer_sheet.dart';

/// FR-043: verify by scanning the QR code printed on a signed document.
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
    final l10n = context.l10n;
    final proceed = await PermissionPrimerSheet.show(
      context,
      icon: Icons.qr_code_scanner_rounded,
      title: l10n.cameraAccess,
      explanation: l10n.cameraPrimerExplanation,
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
      final result = await ref
          .read(apiClientProvider)
          .verifyDocumentById(verificationId);
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQrCode),
        actions: const [LanguageSwitch.compact()],
      ),
      body: !_permissionRequested
          ? const Center(child: CircularProgressIndicator())
          : !_permissionGranted
          ? _PermissionDenied(
              onOpenManual: () =>
                  context.pushReplacement('/documents/verify/manual'),
            )
          : Stack(
              children: [
                MobileScanner(controller: _controller, onDetect: _onDetect),
                if (_processing)
                  const ColoredBox(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
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
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.white),
                        ),
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(ChekkamSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography_outlined,
            size: 48,
            color: ChekkamColors.muted,
          ),
          const SizedBox(height: ChekkamSpacing.lg),
          Text(
            l10n.cameraNotGranted,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChekkamSpacing.sm),
          Text(
            l10n.manualStillAvailable,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ChekkamColors.muted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChekkamSpacing.lg),
          ElevatedButton(
            onPressed: onOpenManual,
            child: Text(l10n.enterIdInstead),
          ),
        ],
      ),
    );
  }
}
