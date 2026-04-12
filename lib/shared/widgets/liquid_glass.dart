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
  final BorderRadius? customRadius;
  final EdgeInsetsGeometry padding;
  final bool dense;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.customRadius,
    this.padding = const EdgeInsets.all(20),
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = customRadius ?? BorderRadius.circular(borderRadius);
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

// ─── LiquidGlassBubble ──────────────────────────────────────────────────────

/// Chat bubble with a tail — one unified frosted-glass shape.
/// [tailRight] = tail on bottom-right (user). false = bottom-left (pet).
class LiquidGlassBubble extends StatelessWidget {
  final Widget child;
  final bool tailRight;

  const LiquidGlassBubble({
    super.key,
    required this.child,
    this.tailRight = false,
  });

  static const double _r = 18.0;
  static const double _tailW = 10.0;
  static const double _tailH = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipPath(
        clipper: _BubbleClipper(r: _r, tailW: _tailW, tailH: _tailH, tailRight: tailRight),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _kBlur, sigmaY: _kBlur),
          child: CustomPaint(
            painter: _BubblePainter(r: _r, tailW: _tailW, tailH: _tailH, tailRight: tailRight),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                tailRight ? 14 : 14,
                11,
                tailRight ? 14 : 14,
                11 + _tailH,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _BubbleClipper extends CustomClipper<Path> {
  final double r, tailW, tailH;
  final bool tailRight;
  const _BubbleClipper({required this.r, required this.tailW, required this.tailH, required this.tailRight});

  @override
  Path getClip(Size s) => _bubblePath(s, r, tailW, tailH, tailRight);

  @override
  bool shouldReclip(_BubbleClipper o) => false;
}

class _BubblePainter extends CustomPainter {
  final double r, tailW, tailH;
  final bool tailRight;
  const _BubblePainter({required this.r, required this.tailW, required this.tailH, required this.tailRight});

  @override
  void paint(Canvas canvas, Size s) {
    final path = _bubblePath(s, r, tailW, tailH, tailRight);
    final rect = Rect.fromLTWH(0, 0, s.width, s.height);

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x85FFFFFF), Color(0x4DFFFFFF), Color(0x2EFFFFFF)],
          stops: [0.0, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x99FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_BubblePainter o) => false;
}

/// Builds the bubble+tail path.
/// [tailRight] = tail on bottom-right (user). false = bottom-left (pet).
Path _bubblePath(Size s, double r, double tailW, double tailH, bool tailRight) {
  final w = s.width;
  final h = s.height;
  final tailY = h - tailH - 4; // Tail anchor position from bottom

  final p = Path();

  if (tailRight) {
    // User bubble (right tail)
    p.moveTo(r, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    p.lineTo(w, tailY);
    // Tail pointing right
    p.lineTo(w + tailW, tailY + tailH / 2); // tip
    p.lineTo(w, tailY + tailH);
    p.lineTo(w, h - r);
    p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    p.lineTo(r, h);
    p.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    p.lineTo(0, r);
    p.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
  } else {
    // Pet bubble (left tail)
    p.moveTo(r + tailW, 0);
    p.lineTo(w - r, 0);
    p.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    p.lineTo(w, h - r);
    p.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    p.lineTo(r + tailW, h);
    p.lineTo(r + tailW, tailY + tailH);
    // Tail pointing left
    p.lineTo(r, tailY + tailH / 2); // tip
    p.lineTo(r + tailW, tailY);
    p.lineTo(r + tailW, r);
    p.arcToPoint(Offset(r + tailW + r, 0), radius: Radius.circular(r));
  }

  p.close();
  return p;
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
