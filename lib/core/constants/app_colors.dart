import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Green Liquid Glass Palette ──

  // Glass Mint — Main background
  static const Color glassMint = Color(0xFFEAF4EE);

  // Frosted Sage — Cards / surfaces
  static const Color frostedSage = Color(0xFFD7E8DC);

  // Liquid Green — Primary accent
  static const Color liquidGreen = Color(0xFF8FBFA3);

  // Deep Moss — Primary buttons / CTA
  static const Color deepMoss = Color(0xFF6F9B84);

  // Soft Jade — Secondary accent
  static const Color softJade = Color(0xFFB9DCC7);

  // Pearl Fog — Glass highlight
  static const Color pearlFog = Color(0xFFF7FBF8);

  // Forest Graphite — Main text
  static const Color forestGraphite = Color(0xFF42554B);

  // Mist Border — Borders / dividers
  static const Color mistBorder = Color(0xFFC7D9CF);

  // ── Semantic aliases ──

  static const Color primary = deepMoss;
  static const Color primaryLight = liquidGreen;
  static const Color primaryDark = Color(0xFF587D6A);

  static const Color secondary = liquidGreen;
  static const Color secondaryLight = softJade;
  static const Color secondaryDark = deepMoss;

  static const Color accent = softJade;
  static const Color accentLight = Color(0xFFD4EDE0);

  static const Color backgroundLight = glassMint;
  static const Color surfaceLight = pearlFog;

  static const Color cardLight = frostedSage;

  static const Color textPrimary = forestGraphite;
  static const Color textSecondary = Color(0xFF6B8277);
  static const Color textLight = pearlFog;
  static const Color textHint = Color(0xFF9BB5A8);

  // Status
  static const Color success = Color(0xFF6DAE5C);
  static const Color error = Color(0xFFD4645C);
  static const Color warning = Color(0xFFE0B44A);
  static const Color info = Color(0xFF5AADCF);

  // ── Gradients ──

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepMoss, liquidGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [glassMint, frostedSage],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Main screen gradient — soft mint to pearl
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFE2F0E7), glassMint, pearlFog],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Liquid Glass (iOS 26 / Apple Vision Pro style) ──

  // Glass fill — nearly transparent, the blur does the heavy lifting
  static LinearGradient get glassGradient => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.22),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.03),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // Slightly denser glass for small interactive elements (icons, pills)
  static LinearGradient get glassGradientStrong => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.45, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // Thin border — subtle white edge
  static Color get glassBorder => Colors.white.withValues(alpha: 0.45);

  // Even subtler for secondary edges
  static Color get glassBorderSubtle => Colors.white.withValues(alpha: 0.20);

  // Top-edge highlight — bright refraction line at the top of glass
  static Color get glassHighlight => Colors.white.withValues(alpha: 0.55);

  // Soft diffuse outer shadow
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: deepMoss.withValues(alpha: 0.06),
          blurRadius: 40,
          spreadRadius: -4,
        ),
      ];

  // Blur sigma
  static const double glassBlurSigma = 30.0;
  static const double glassBlurSigmaSmall = 20.0;
}
