import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final appLocaleProvider = NotifierProvider<AppLocaleController, Locale>(
  AppLocaleController.new,
);

class AppLocaleController extends Notifier<Locale> {
  static const _storage = FlutterSecureStorage();
  static const _storageKey = 'chekkam_language';
  static const supportedLanguageCodes = {'en', 'fr'};

  @override
  Locale build() {
    unawaited(_loadSavedLanguage());
    return const Locale('en');
  }

  Future<void> setLanguage(String languageCode) async {
    if (!supportedLanguageCodes.contains(languageCode)) return;
    state = Locale(languageCode);
    try {
      await _storage.write(key: _storageKey, value: languageCode);
    } catch (_) {
      // The language still changes for this session if secure storage is not available.
    }
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final languageCode = await _storage.read(key: _storageKey);
      if (languageCode != null &&
          supportedLanguageCodes.contains(languageCode)) {
        state = Locale(languageCode);
      }
    } catch (_) {
      // Keep the default locale when persisted preferences cannot be read.
    }
  }
}
