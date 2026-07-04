import 'package:permission_handler/permission_handler.dart';

/// Thin wrapper over permission_handler. SRS Section 7 is a hard constraint:
/// every request must be explicit, contextual, and triggered only by the
/// specific action that needs it — never pre-checked, never bundled, never
/// requested "just in case." Callers are expected to show their own
/// plain-language "why we're asking" UI *before* calling these (see
/// PermissionPrimerSheet in widgets/), then call the matching method here,
/// which triggers the actual OS dialog.
class PermissionsService {
  const PermissionsService();

  Future<bool> requestCamera() => _request(Permission.camera);

  Future<bool> requestPhotos() => _request(Permission.photos);

  Future<bool> requestLocation() => _request(Permission.locationWhenInUse);

  Future<bool> requestNotifications() => _request(Permission.notification);

  Future<bool> _request(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    final result = await permission.request();
    return result.isGranted;
  }
}
