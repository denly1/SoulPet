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

  // Glass surface gradient
  static LinearGradient get glassGradient => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.45),
          Colors.white.withValues(alpha: 0.15),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Glass border color
  static Color get glassBorder => Colors.white.withValues(alpha: 0.55);

  // Glass shadow
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: liquidGreen.withValues(alpha: 0.12),
          blurRadius: 24,
          spreadRadius: 2,
        ),
      ];
}
