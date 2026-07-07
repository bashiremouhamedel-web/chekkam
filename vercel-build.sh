#!/usr/bin/env bash
<<<<<<< HEAD
# Builds the Flutter web app on Vercel, which has no Flutter SDK preinstalled.
# Reads API_BASE_URL / SUPABASE_URL / SUPABASE_ANON_KEY from Vercel Project ->
# Environment Variables and bakes them in via --dart-define (Flutter web has
# no runtime config mechanism — see lib/app/config.dart).
set -euo pipefail

if [ ! -d "flutter-sdk" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 --branch stable flutter-sdk
fi
export PATH="$PWD/flutter-sdk/bin:$PATH"

flutter doctor -v
flutter pub get

flutter build web --release \
  --dart-define=API_BASE_URL="${API_BASE_URL:-}" \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"
=======
set -e

FLUTTER_DIR="${VERCEL_CACHE_DIR:-/tmp}/flutter"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web
flutter pub get
flutter build web --release --dart-define=API_BASE_URL="${API_BASE_URL}"
>>>>>>> a699392813bd6c85bde50d6c8526c2d9d50910f0
