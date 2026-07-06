#!/usr/bin/env bash
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
