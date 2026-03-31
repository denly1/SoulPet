import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Liquid Glass container inspired by iOS 26 / Apple Vision Pro.
///
/// Layers (bottom → top):
/// 1. BackdropFilter — strong Gaussian blur of content behind
/// 2. Semi-transparent fill gradient (top-lit, nearly clear)
/// 3. Inner top-edge highlight (thin bright line imitating refraction)
/// 4. Thin uniform border
/// 5. Soft diffuse outer shadow
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
    final sigma = dense
        ? AppColors.glassBlurSigmaSmall
        : AppColors.glassBlurSigma;
    final gradient = dense
        ? AppColors.glassGradientStrong
        : AppColors.glassGradient;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 0.5,
            ),
            boxShadow: AppColors.glassShadow,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border(
              top: BorderSide(
                color: AppColors.glassHighlight,
                width: 1.0,
              ),
            ),
          ),
          child: child,
        ),
      ),
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
    final content = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigmaSmall,
          sigmaY: AppColors.glassBlurSigmaSmall,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.glassGradientStrong,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 0.5,
            ),
            boxShadow: AppColors.glassShadow,
          ),
          child: Center(child: child),
        ),
      ),
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
    final pill = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigmaSmall,
          sigmaY: AppColors.glassBlurSigmaSmall,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: AppColors.glassGradientStrong,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: pill);
    }
    return pill;
  }
}
