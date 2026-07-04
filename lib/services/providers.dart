import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'permissions_service.dart';
import 'supabase_service.dart';

/// Provides an [ApiClient] carrying the current Supabase session's access
/// token when one exists (most citizen flows are anonymous, per FR-005).
final apiClientProvider = Provider<ApiClient>((ref) {
  final token = SupabaseService.clientOrNull?.auth.currentSession?.accessToken;
  return ApiClient(accessToken: token);
});

final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return const PermissionsService();
});
