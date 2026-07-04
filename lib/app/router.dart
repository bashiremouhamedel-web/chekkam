import 'package:go_router/go_router.dart';

import '../features/alerts/public_alerts_screen.dart';
import '../features/documents/manual_verify_screen.dart';
import '../features/documents/scan_screen.dart';
import '../features/documents/upload_verify_screen.dart';
import '../features/documents/verify_hub_screen.dart';
import '../features/documents/verify_result_screen.dart';
import '../features/home/home_screen.dart';
import '../features/reports/report_form_screen.dart';
import '../features/reports/report_result_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/documents/verify',
      builder: (context, state) => const VerifyHubScreen(),
    ),
    GoRoute(
      path: '/documents/verify/scan',
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: '/documents/verify/manual',
      builder: (context, state) => const ManualVerifyScreen(),
    ),
    GoRoute(
      path: '/documents/verify/upload',
      builder: (context, state) => const UploadVerifyScreen(),
    ),
    GoRoute(
      path: '/documents/verify/result',
      builder: (context, state) =>
          VerifyResultScreen(result: state.extra as Map<String, dynamic>? ?? const {}),
    ),
    GoRoute(
      path: '/reports/new',
      builder: (context, state) => const ReportFormScreen(),
    ),
    GoRoute(
      path: '/reports/result',
      builder: (context, state) =>
          ReportResultScreen(report: state.extra as Map<String, dynamic>? ?? const {}),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const PublicAlertsScreen(),
    ),
  ],
);
