import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/locale_controller.dart';
import 'api_client.dart';
import 'permissions_service.dart';
import 'supabase_service.dart';

/// Provides an [ApiClient] carrying the current Supabase session's access
/// token when one exists (most citizen flows are anonymous, per FR-005).
final apiClientProvider = Provider<ApiClient>((ref) {
  final token = SupabaseService.clientOrNull?.auth.currentSession?.accessToken;
  final locale = ref.watch(appLocaleProvider);
  return ApiClient(accessToken: token, languageCode: locale.languageCode);
});

final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return const PermissionsService();
});
