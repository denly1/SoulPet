import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Shared glass settings for the SoulPet app.
const _defaultSettings = LiquidGlassSettings(
  thickness: 0.7,
  blur: 18.0,
  refractiveIndex: 1.4,
  glassColor: Color(0x18FFFFFF),
  lightAngle: 55.0,
  lightIntensity: 0.75,
  ambientStrength: 0.35,
  saturation: 1.1,
  chromaticAberration: 0.001,
);

const _denseSettings = LiquidGlassSettings(
  thickness: 0.85,
  blur: 12.0,
  refractiveIndex: 1.5,
  glassColor: Color(0x22FFFFFF),
  lightAngle: 55.0,
  lightIntensity: 0.8,
  ambientStrength: 0.3,
  saturation: 1.15,
  chromaticAberration: 0.001,
);

/// Liquid Glass card — shader-based iOS 26 glass effect.
///
/// Uses [GlassContainer] from `liquid_glass_widgets` package
/// with real fragment-shader refraction and blur.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool dense;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(20),
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      useOwnLayer: true,
      settings: dense ? _denseSettings : _defaultSettings,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      padding: padding,
      child: child,
    );
  }
}

/// Circular liquid glass element (nav icons, avatars, small buttons).
class LiquidGlassCircle extends StatelessWidget {
  final double size;
  final Widget child;
  final VoidCallback? onTap;

  const LiquidGlassCircle({
    super.key,
    required this.size,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = GlassContainer(
      useOwnLayer: true,
      width: size,
      height: size,
      settings: _denseSettings,
      shape: const LiquidOval(),
      child: Center(child: child),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

/// Rounded-rect liquid glass pill (small badges, tags, status bars).
class LiquidGlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const LiquidGlassPill({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pill = GlassContainer(
      useOwnLayer: true,
      settings: _denseSettings,
      shape: const LiquidRoundedSuperellipse(borderRadius: 100),
      padding: padding,
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: pill);
    }
    return pill;
  }
}
