import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — warm brown from SoulPet logo
  static const Color primary = Color(0xFF8B6914);
  static const Color primaryLight = Color(0xFFB8942A);
  static const Color primaryDark = Color(0xFF6B4F0E);

  // Secondary — soft warm beige
  static const Color secondary = Color(0xFFD4A855);
  static const Color secondaryLight = Color(0xFFE8C97A);
  static const Color secondaryDark = Color(0xFFA07A2E);

  // Accent — golden highlight
  static const Color accent = Color(0xFFE8B830);
  static const Color accentLight = Color(0xFFF5D76E);

  // Background — warm creamy beige
  static const Color backgroundLight = Color(0xFFF7F0E3);
  static const Color backgroundDark = Color(0xFF2C2416);
  static const Color surfaceLight = Color(0xFFFFF8ED);
  static const Color surfaceDark = Color(0xFF3D3222);

  // Card
  static const Color cardLight = Color(0xFFFFFDF7);
  static const Color cardDark = Color(0xFF4A3D2A);

  // Text
  static const Color textPrimary = Color(0xFF3E2C12);
  static const Color textSecondary = Color(0xFF8A7560);
  static const Color textLight = Color(0xFFFFFDF7);
  static const Color textHint = Color(0xFFBBA98E);

  // Status
  static const Color success = Color(0xFF6DAE5C);
  static const Color error = Color(0xFFD4645C);
  static const Color warning = Color(0xFFE8B830);
  static const Color info = Color(0xFF5AADCF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4A855), Color(0xFFE8C97A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF7F0E3), Color(0xFFEDE1CC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF5E6C8), Color(0xFFEDD5A6), Color(0xFFF7F0E3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
