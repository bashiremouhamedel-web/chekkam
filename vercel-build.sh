#!/usr/bin/env bash
set -euo pipefail

# Builds Flutter web on Vercel. Flutter is not preinstalled on Vercel.
FLUTTER_DIR="${VERCEL_CACHE_DIR:-/tmp}/flutter"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web
flutter --version
flutter pub get

flutter build web --release \
  --dart-define=API_BASE_URL="${API_BASE_URL:-}" \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"
