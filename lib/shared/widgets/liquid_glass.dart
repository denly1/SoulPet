import 'dart:ui';
import 'package:flutter/material.dart';

// ─── Glass design tokens ────────────────────────────────────────────────────

const double _kBlur = 22.0;
const double _kBlurSmall = 14.0;

// White fill — soft frosted
LinearGradient _glassGradient() => LinearGradient(
      colors: [
        const Color(0xFFFFFFFF).withValues(alpha: 0.52),
        const Color(0xFFFFFFFF).withValues(alpha: 0.30),
        const Color(0xFFFFFFFF).withValues(alpha: 0.18),
      ],
      stops: const [0.0, 0.55, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

// Top-left highlight refraction line
Color _glassHighlight() => const Color(0xFFFFFFFF).withValues(alpha: 0.80);

// Border
Color _glassBorder() => const Color(0xFFFFFFFF).withValues(alpha: 0.60);

// Outer shadow
List<BoxShadow> _glassShadow() => [
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.07),
        blurRadius: 24,
        spreadRadius: 0,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: const Color(0xFF6F9B84).withValues(alpha: 0.10),
        blurRadius: 36,
        spreadRadius: -4,
        offset: const Offset(0, 4),
      ),
    ];

// ─── LiquidGlassCard ────────────────────────────────────────────────────────

/// Frosted-glass card with crisp corners, no clipping artifacts.
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
    final r = BorderRadius.circular(borderRadius);
    final sigma = dense ? _kBlurSmall : _kBlur;

    return Container(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: _glassShadow(),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: r,
              gradient: _glassGradient(),
              border: Border.all(
                color: _glassBorder(),
                width: 1.0,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: r,
              border: Border(
                top: BorderSide(color: _glassHighlight(), width: 1.2),
                left: BorderSide(
                    color: _glassHighlight().withValues(alpha: 0.45), width: 0.8),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─── LiquidGlassCircle ──────────────────────────────────────────────────────

/// Circular frosted-glass element — perfect circle, crisp edges.
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
    final content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _kBlurSmall, sigmaY: _kBlurSmall),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFFFFF).withValues(alpha: 0.65),
                  const Color(0xFFFFFFFF).withValues(alpha: 0.35),
                  const Color(0xFFFFFFFF).withValues(alpha: 0.20),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.65),
                width: 1.0,
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

// ─── LiquidGlassPill ────────────────────────────────────────────────────────

/// Pill-shaped frosted-glass badge / tag.
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
        filter: ImageFilter.blur(sigmaX: _kBlurSmall, sigmaY: _kBlurSmall),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: _glassGradient(),
            border: Border.all(color: _glassBorder(), width: 1.0),
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
