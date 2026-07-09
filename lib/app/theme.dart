import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand tokens — v3 (bold red/maroon/ink identity, Fraunces/Inter/Plex Mono
/// type system unchanged). Keep this file as the single source of truth for
/// color/type/spacing/radius/shadow so the app never drifts as screens are
/// added. See Chekkam_Brand_Guide.md for the full rationale.
class ChekkamColors {
  ChekkamColors._();

  // Brand — vivid red is the trust/action anchor; deep maroon is the dark
  // surface/hero anchor. Danger status deliberately reuses the maroon (not
  // primary) so a "Tampered" badge never looks identical to an ordinary
  // button — see §3.2 in the brand guide.
  static const maroon = Color(0xFF68020F); // deepest red — hero/dark surfaces
  static const primary = Color(0xFFF21137); // primary actions, links
  static const secondary = Color(0xFFF21137);
  static const brightRed = Color(0xFFFF3355); // hover/active/gradient highlight

  // Neutrals — true near-black ink, near-white surface, per brand palette.
  static const ink = Color(0xFF030303);
  static const muted = Color(0xFF4A4A4A);
  static const faint = Color(0xFF8A8080);
  static const surface = Color(0xFFFFFFFE); // page background
  static const surfaceRaised = Color(0xFFFFFFFF); // card fill
  static const tint = Color(0xFFF7F1F1); // recessed sections / fields
  static const border = Color(0xFFE8DEDE);
  static const white = Color(0xFFFFFFFF);

  // Semantic status — success/warning stay distinct hues from the brand red;
  // danger intentionally uses the brand's own maroon (§3.2 in the guide
  // explains why that's still safe: paired with icon + label everywhere).
  static const success = Color(0xFF1E8E5A);
  static const warning = Color(0xFFB5690F);
  static const danger = Color(0xFF68020F);
  static const neutral = Color(0xFF7C7272);

  static const gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [maroon, primary],
  );

  static const gradientSeal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, ink],
  );

  static LinearGradient gradientForStatus(ChekkamStatus status) {
    final base = status.color;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [base, Color.lerp(base, Colors.black, 0.28)!],
    );
  }
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

/// Bigger, softer radii than v1 — 2026 direction favors depth over hard edges.
class ChekkamRadius {
  ChekkamRadius._();

  static const small = 10.0;
  static const card = 20.0;
  static const hero = 26.0;
  static const pill = 9999.0;
}

/// Soft layered shadows instead of hard borders — used via [BoxDecoration.boxShadow].
class ChekkamShadows {
  ChekkamShadows._();

  static List<BoxShadow> get sm => [
        BoxShadow(color: ChekkamColors.ink.withValues(alpha: 0.05), blurRadius: 3, offset: const Offset(0, 1)),
      ];

  static List<BoxShadow> get md => [
        BoxShadow(color: ChekkamColors.ink.withValues(alpha: 0.10), blurRadius: 20, offset: const Offset(0, 8)),
        BoxShadow(color: ChekkamColors.ink.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
      ];

  static List<BoxShadow> get lg => [
        BoxShadow(color: ChekkamColors.ink.withValues(alpha: 0.18), blurRadius: 40, offset: const Offset(0, 16)),
        BoxShadow(color: ChekkamColors.ink.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3)),
      ];
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

  /// Fraunces — a warm display serif that nods to certificates, seals, and
  /// letterheads (the world Chekkam's document-signing side lives in)
  /// instead of another geometric sans. Used with restraint: verdicts,
  /// headlines, big numerals.
  static TextStyle display({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    Color? color,
    double? height,
  }) =>
      GoogleFonts.fraunces(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color ?? ChekkamColors.ink,
        height: height,
      );

  /// IBM Plex Mono — verification IDs, PINs, timestamps: anything meant to
  /// be scanned character-by-character reads better tabular.
  static TextStyle mono({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? letterSpacing,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? ChekkamColors.ink,
        letterSpacing: letterSpacing ?? 0.4,
      );

  static ThemeData get light {
    final headingFont = GoogleFonts.frauncesTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    final textTheme = bodyFont.copyWith(
      displayLarge: headingFont.displayLarge?.copyWith(color: ChekkamColors.ink),
      headlineLarge: headingFont.headlineLarge?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -0.5,
      ),
      headlineMedium: headingFont.headlineMedium?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.12,
        letterSpacing: -0.3,
      ),
      headlineSmall: headingFont.headlineSmall?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 23,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      titleLarge: headingFont.titleLarge?.copyWith(
        color: ChekkamColors.ink,
        fontSize: 19,
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
        height: 1.45,
      ),
      bodySmall: bodyFont.bodySmall?.copyWith(color: ChekkamColors.muted),
      labelLarge: bodyFont.labelLarge?.copyWith(
        color: ChekkamColors.ink,
        fontWeight: FontWeight.w600,
      ),
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: ChekkamColors.primary,
      brightness: Brightness.light,
      primary: ChekkamColors.primary,
      secondary: ChekkamColors.brightRed,
      surface: ChekkamColors.surfaceRaised,
      error: ChekkamColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ChekkamColors.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: ChekkamColors.surface,
        foregroundColor: ChekkamColors.ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: ChekkamColors.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.card),
          side: const BorderSide(color: ChekkamColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChekkamColors.primary,
          foregroundColor: ChekkamColors.white,
          disabledBackgroundColor: ChekkamColors.primary.withValues(alpha: 0.45),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shadowColor: ChekkamColors.primary.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ChekkamRadius.small),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChekkamColors.primary,
          side: const BorderSide(color: ChekkamColors.primary, width: 1.4),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ChekkamRadius.small),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ChekkamColors.primary,
          textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChekkamColors.tint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ChekkamSpacing.lg,
          vertical: ChekkamSpacing.md + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ChekkamRadius.small),
          borderSide: const BorderSide(color: ChekkamColors.primary, width: 2),
        ),
        hintStyle: TextStyle(color: ChekkamColors.faint),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: ChekkamColors.tint,
          selectedBackgroundColor: ChekkamColors.primary,
          selectedForegroundColor: ChekkamColors.white,
          foregroundColor: ChekkamColors.muted,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ChekkamRadius.small)),
        ),
      ),
      dividerColor: ChekkamColors.border,
      dividerTheme: const DividerThemeData(color: ChekkamColors.border, thickness: 1),
    );
  }
}
