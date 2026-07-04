import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand tokens from Chekkam_Brand_Guide.md Sections 3-4, 7, 10-11.
/// Keep this file as the single source of truth for color/type/spacing/radius
/// so the app never drifts from the brand guide as screens are added.
class ChekkamColors {
  ChekkamColors._();

  static const primary = Color(0xFF028090); // Primary Teal
  static const secondary = Color(0xFF00A896); // Secondary Seafoam
  static const accent = Color(0xFF02C39A); // Accent Mint
  static const ink = Color(0xFF1E293B); // Body text / headings
  static const muted = Color(0xFF64748B); // Secondary text
  static const tint = Color(0xFFE9F5F4); // Card fill
  static const tint2 = Color(0xFFF5FAF9); // Section background
  static const white = Color(0xFFFFFFFF);

  // Semantic / status colors — deliberately distinct from brand accents (§3.2).
  static const success = Color(0xFF16A34A); // Genuine / low risk
  static const warning = Color(0xFFF59E0B); // Medium risk / pending
  static const danger = Color(0xFFDC2626); // Tampered / high-critical risk
  static const neutral = Color(0xFF64748B); // Revoked / not found
}

class ChekkamSpacing {
  ChekkamSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
  static const huge = 64.0;
}

class ChekkamRadius {
  ChekkamRadius._();

  static const small = 6.0;
  static const card = 12.0;
  static const pill = 9999.0;
}

/// Status colors are never the only signal — always pair with an icon + text
/// label in the widget itself (Brand Guide §3.2, §8 accessibility rule).
enum ChekkamStatus { success, warning, danger, neutral }

extension ChekkamStatusColor on ChekkamStatus {
  Color get color => switch (this) {
        ChekkamStatus.success => ChekkamColors.success,
        ChekkamStatus.warning => ChekkamColors.warning,
        ChekkamStatus.danger => ChekkamColors.danger,
        ChekkamStatus.neutral => ChekkamColors.neutral,
      };
}

class ChekkamTheme {
  ChekkamTheme._();

  static ThemeData get light {
    final headingFont = GoogleFonts.soraTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    final textTheme = bodyFont.copyWith(
      displayLarge: headingFont.displayLarge?.copyWith(color: ChekkamColors.ink),
      headlineLarge: headingFont.headlineLarge?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineMedium: headingFont.headlineMedium?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineSmall: headingFont.headlineSmall?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: headingFont.titleLarge?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: bodyFont.bodyLarge?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: bodyFont.bodyMedium?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 14,
        height: 1.4,
      ),
      bodySmall: bodyFont.bodySmall?.copyWith(color: ChekkamColors.muted),
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: ChekkamColors.primary,
      brightness: Brightness.light,
      primary: ChekkamColors.primary,
      secondary: ChekkamColors.secondary,
      surface: ChekkamColors.white,
      error: ChekkamColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ChekkamColors.white,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: ChekkamColors.white,
        foregroundColor: ChekkamColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: ChekkamColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.card),
          side: const BorderSide(color: Color(0xFFE2E8E7)),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChekkamColors.primary,
          foregroundColor: ChekkamColors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ChekkamRadius.small),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChekkamColors.primary,
          side: const BorderSide(color: ChekkamColors.primary),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ChekkamRadius.small),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChekkamColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ChekkamSpacing.lg,
          vertical: ChekkamSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: const BorderSide(color: Color(0xFFE2E8E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: const BorderSide(color: Color(0xFFE2E8E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: const BorderSide(color: ChekkamColors.primary, width: 2),
        ),
      ),
      dividerColor: const Color(0xFFE2E8E7),
    );
  }
}
