import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initIfConfigured();
  runApp(const ProviderScope(child: ChekkamApp()));
}

class ChekkamApp extends StatelessWidget {
  const ChekkamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chekkam',
      debugShowCheckedModeBanner: false,
      theme: ChekkamTheme.light,
      routerConfig: appRouter,
    );
  }
}
