#!/usr/bin/env bash
set -e

FLUTTER_DIR="${VERCEL_CACHE_DIR:-/tmp}/flutter"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web
flutter pub get
flutter build web --release --dart-define=API_BASE_URL="${API_BASE_URL}"
