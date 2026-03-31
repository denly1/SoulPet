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

  // Glass fill — visible frosted white, background bleeds through blur
  static LinearGradient get glassGradient => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.55),
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.25),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // Denser glass for small interactive elements (icons, pills, action buttons)
  static LinearGradient get glassGradientStrong => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.70),
          Colors.white.withValues(alpha: 0.45),
          Colors.white.withValues(alpha: 0.30),
        ],
        stops: const [0.0, 0.45, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // Border — visible white edge like real glass
  static Color get glassBorder => Colors.white.withValues(alpha: 0.75);

  // Subtler border for secondary edges
  static Color get glassBorderSubtle => Colors.white.withValues(alpha: 0.40);

  // Top-edge highlight — bright refraction line at the top of glass
  static Color get glassHighlight => Colors.white.withValues(alpha: 0.85);

  // Visible outer shadow — gives depth to glass cards
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: deepMoss.withValues(alpha: 0.12),
          blurRadius: 32,
          spreadRadius: -2,
          offset: const Offset(0, 4),
        ),
      ];

  // Blur sigma — strong enough to see frosted effect
  static const double glassBlurSigma = 24.0;
  static const double glassBlurSigmaSmall = 16.0;
}
