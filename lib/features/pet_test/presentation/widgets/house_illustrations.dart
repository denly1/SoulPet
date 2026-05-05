import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Premium, minimalist illustrations of the two living options the user picks
/// for their pet — an Apartment (modern mid-rise) and a House (cozy cottage).
///
/// Both are rendered procedurally on a 200×160 logical canvas and scaled to
/// whatever size the widget is given. They share a single soft mint→pearl
/// background, clean geometry, and a restrained palette derived from the
/// app's green "liquid glass" design system, so the picker feels like a pair
/// of editorial product cards rather than busy cartoon scenes.

// ─── Public widgets ────────────────────────────────────────────────────────

class ApartmentIllustration extends StatelessWidget {
  final double width;
  final double height;
  const ApartmentIllustration({
    super.key,
    this.width = double.infinity,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const _IllustrationFrame(
        child: CustomPaint(painter: _ApartmentPainter()),
      ),
    );
  }
}

class HouseIllustration extends StatelessWidget {
  final double width;
  final double height;
  const HouseIllustration({
    super.key,
    this.width = double.infinity,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const _IllustrationFrame(
        child: CustomPaint(painter: _HousePainter()),
      ),
    );
  }
}

/// Shared backdrop: vertical mint-to-pearl gradient with two soft jade bokeh
/// blobs that hint at depth without competing with the building.
class _IllustrationFrame extends StatelessWidget {
  final Widget child;
  const _IllustrationFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE2F0E7), // glassMint top
            Color(0xFFEAF4EE),
            Color(0xFFF7FBF8), // pearlFog
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _BackdropPainter()),
          child,
        ],
      ),
    );
  }
}

// ─── Palette ───────────────────────────────────────────────────────────────

class _P {
  // App palette
  static const glassMint = Color(0xFFEAF4EE);
  static const frostedSage = Color(0xFFD7E8DC);
  static const liquidGreen = Color(0xFF8FBFA3);
  static const deepMoss = Color(0xFF6F9B84);
  static const softJade = Color(0xFFB9DCC7);
  static const mistBorder = Color(0xFFC7D9CF);

  // Illustration accents
  static const wallTop = Color(0xFFFBFFFC);
  static const wallBottom = Color(0xFFE7F1EA);
  static const wallSide = Color(0xFFCBDDD0);
  static const wallShade = Color(0xFFB9CFC0);
  static const roofTop = Color(0xFF7AAB91);
  static const roofBottom = Color(0xFF587D6A);
  static const roofTrim = Color(0xFF42554B);
  static const glassTop = Color(0xFFD7EAE0);
  static const glassBottom = Color(0xFFB7D2C2);
  static const glassWarm = Color(0xFFFFE6B8); // lit window
  static const door = Color(0xFF42554B);
  static const doorWarm = Color(0xFF6F9B84);
  static const handle = Color(0xFFE9C46A);
  static const trunk = Color(0xFF7A6048);
  static const trunkDark = Color(0xFF553F2C);
  static const leaves = Color(0xFF7AAB91);
  static const leavesDark = Color(0xFF587D6A);
  static const leavesLight = Color(0xFFB9DCC7);
  static const path = Color(0xFFE0EAE2);
  static const pathDark = Color(0xFFC2D5C8);
  static const ground = Color(0xFFD8E7DD);
  static const groundShade = Color(0xFFBFD3C6);
}

// ─── Backdrop (shared) ─────────────────────────────────────────────────────

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Two soft jade orbs for depth, blurred. Top-left is bigger.
    final p = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.20),
      size.width * 0.18,
      p..color = _P.softJade.withValues(alpha: 0.45),
    );
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.30),
      size.width * 0.13,
      p..color = _P.liquidGreen.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) => false;
}

// ─── Apartment painter ─────────────────────────────────────────────────────

class _ApartmentPainter extends CustomPainter {
  const _ApartmentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Uniform scale + center so the building keeps its real proportions even
    // when the host card is much wider than it is tall.
    final scale = math.min(size.width / 200.0, size.height / 160.0);
    final dx = (size.width - 200 * scale) / 2;
    final dy = (size.height - 160 * scale) / 2;

    // Full-card-width ground band (kept in pixel space so it reaches both
    // edges regardless of the centered scene's width).
    _drawFullWidthGround(canvas, size, scale, dy);

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    _drawNeighbour(canvas);
    _drawBuildingShadow(canvas);
    _drawSideWall(canvas);
    _drawFrontWall(canvas);
    _drawWindows(canvas);
    _drawBalconies(canvas);
    _drawEntrance(canvas);
    _drawRooftop(canvas);
    _drawStreetTree(canvas);

    canvas.restore();
  }

  void _drawFullWidthGround(Canvas c, Size size, double scale, double dy) {
    final groundTop = dy + 144 * scale;
    final groundBottom = math.max(size.height, dy + 160 * scale);
    // Soft contact shadow under the building, widened to the card.
    c.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, dy + 148 * scale),
        width: size.width * 1.1,
        height: 26 * scale,
      ),
      Paint()
        ..color = _P.frostedSage.withValues(alpha: 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );
    c.drawRect(
      Rect.fromLTWH(0, groundTop, size.width, groundBottom - groundTop),
      Paint()..color = _P.ground.withValues(alpha: 0.9),
    );
    c.drawLine(
      Offset(0, groundTop),
      Offset(size.width, groundTop),
      Paint()
        ..color = _P.mistBorder.withValues(alpha: 0.8)
        ..strokeWidth = 0.8,
    );
  }

  void _drawNeighbour(Canvas c) {
    // A single softer building behind on the right — silhouette only.
    final r = RRect.fromRectAndCorners(
      const Rect.fromLTWH(146, 56, 40, 88),
      topLeft: const Radius.circular(6),
      topRight: const Radius.circular(6),
    );
    c.drawRRect(r, Paint()..color = _P.frostedSage);
    c.drawRRect(
      r,
      Paint()
        ..color = _P.mistBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    // A few ghosted windows.
    final win = Paint()..color = _P.glassMint.withValues(alpha: 0.85);
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 2; col++) {
        c.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(152.0 + col * 14, 64.0 + row * 14, 9, 8),
            const Radius.circular(1.5),
          ),
          win,
        );
      }
    }
  }

  void _drawBuildingShadow(Canvas c) {
    final shadow = Path()
      ..addRRect(RRect.fromRectAndCorners(
        const Rect.fromLTWH(40, 40, 96, 104),
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      ));
    c.drawPath(
      shadow.shift(const Offset(2, 4)),
      Paint()
        ..color = _P.deepMoss.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _drawSideWall(Canvas c) {
    // Slim parallelogram on the right gives a hint of 3D without going full
    // isometric — keeps the silhouette readable on a small card.
    final side = Path()
      ..moveTo(136, 40)
      ..lineTo(144, 46)
      ..lineTo(144, 144)
      ..lineTo(136, 144)
      ..close();
    c.drawPath(
      side,
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.wallSide, _P.wallShade],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(132, 40, 16, 110)),
    );
    c.drawPath(
      side,
      Paint()
        ..color = _P.mistBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawFrontWall(Canvas c) {
    const wall = Rect.fromLTWH(40, 40, 96, 104);
    final r = RRect.fromRectAndCorners(
      wall,
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
    );
    c.drawRRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.wallTop, _P.wallBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(wall),
    );
    // Subtle vertical seam down the center for architectural detail.
    c.drawLine(
      const Offset(88, 44),
      const Offset(88, 140),
      Paint()
        ..color = _P.frostedSage.withValues(alpha: 0.7)
        ..strokeWidth = 0.8,
    );
    c.drawRRect(
      r,
      Paint()
        ..color = _P.mistBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  void _drawWindows(Canvas c) {
    // 2 columns × 4 rows of large modern picture windows.
    const startX = 50.0;
    const startY = 50.0;
    const winW = 32.0;
    const winH = 16.0;
    const gapX = 8.0;
    const gapY = 8.0;
    const lit = {1, 4, 6}; // index r*2+c

    for (int r = 0; r < 4; r++) {
      for (int col = 0; col < 2; col++) {
        final idx = r * 2 + col;
        final rect = Rect.fromLTWH(
          startX + col * (winW + gapX),
          startY + r * (winH + gapY),
          winW,
          winH,
        );
        _drawWindow(c, rect, isLit: lit.contains(idx));
      }
    }
  }

  void _drawWindow(Canvas c, Rect rect, {required bool isLit}) {
    final r = RRect.fromRectAndRadius(rect, const Radius.circular(2.5));
    // Subtle frame
    c.drawRRect(
      RRect.fromRectAndRadius(
        rect.inflate(1.2),
        const Radius.circular(3.5),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
    // Glass — gradient from mint sky reflection at top to warmer fog at the
    // bottom. Lit windows get a soft amber tint instead.
    c.drawRRect(
      r,
      Paint()
        ..shader = LinearGradient(
          colors: isLit
              ? const [_P.glassWarm, Color(0xFFF6CB85)]
              : const [_P.glassTop, _P.glassBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );
    // Vertical mullion in the middle.
    c.drawLine(
      Offset(rect.center.dx, rect.top + 1),
      Offset(rect.center.dx, rect.bottom - 1),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.2,
    );
    // Highlight reflection — a thin diagonal sliver on the upper-left pane.
    final hi = Path()
      ..moveTo(rect.left + 2, rect.top + rect.height * 0.55)
      ..lineTo(rect.left + 2, rect.top + 2)
      ..lineTo(rect.left + rect.width * 0.45, rect.top + 2)
      ..close();
    c.drawPath(
      hi,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );
    c.drawRRect(
      r,
      Paint()
        ..color = _P.deepMoss.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  void _drawBalconies(Canvas c) {
    // Slim balcony rails under rows 1 and 3. Floats just below the windows.
    for (final y in const [70.0, 118.0]) {
      // Slab
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(46, y, 84, 3),
          const Radius.circular(1.5),
        ),
        Paint()..color = _P.deepMoss,
      );
      // Vertical pickets
      final rail = Paint()
        ..color = _P.liquidGreen
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;
      for (double x = 49; x <= 128; x += 4) {
        c.drawLine(Offset(x, y - 6), Offset(x, y), rail);
      }
      // Top rail
      c.drawLine(
        Offset(46, y - 6),
        Offset(130, y - 6),
        Paint()
          ..color = _P.deepMoss
          ..strokeWidth = 1.1,
      );
    }

    // A potted plant on the lower balcony for life.
    c.drawRect(
      const Rect.fromLTWH(56, 116, 6, 4),
      Paint()..color = _P.trunk,
    );
    c.drawCircle(const Offset(59, 112), 4.5, Paint()..color = _P.leaves);
    c.drawCircle(
        const Offset(57, 110), 2.5, Paint()..color = _P.leavesLight);
  }

  void _drawEntrance(Canvas c) {
    // Glass double-door with deep moss frame.
    const door = Rect.fromLTWH(80, 122, 16, 22);
    final dr = RRect.fromRectAndCorners(
      door,
      topLeft: const Radius.circular(7),
      topRight: const Radius.circular(7),
    );
    c.drawRRect(dr, Paint()..color = _P.door);
    // Inner glass panel
    c.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(82.5, 124.5, 11, 17),
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.glassWarm, Color(0xFFF6CB85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(82, 124, 12, 18)),
    );
    // Vertical seam between two doors.
    c.drawLine(
      const Offset(88, 126),
      const Offset(88, 142),
      Paint()
        ..color = _P.door
        ..strokeWidth = 1.0,
    );
    // Step / entry mat
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(76, 144, 24, 3),
        const Radius.circular(1.5),
      ),
      Paint()..color = _P.groundShade,
    );

    // Number plate above door
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(83, 116, 10, 4),
        const Radius.circular(1),
      ),
      Paint()..color = _P.deepMoss,
    );
  }

  void _drawRooftop(Canvas c) {
    // Slim parapet band.
    c.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(38, 36, 100, 8),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.roofTop, _P.roofBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(38, 36, 100, 8)),
    );
    c.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(38, 36, 100, 8),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      Paint()
        ..color = _P.roofTrim.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );

    // Antenna / pole + small disc.
    c.drawLine(
      const Offset(118, 36),
      const Offset(118, 22),
      Paint()
        ..color = _P.roofTrim
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
    c.drawCircle(
      const Offset(118, 21),
      1.6,
      Paint()..color = _P.deepMoss,
    );

    // Rooftop greenery on the left.
    c.drawCircle(const Offset(50, 32), 5, Paint()..color = _P.leaves);
    c.drawCircle(const Offset(56, 31), 4, Paint()..color = _P.leavesLight);
    c.drawCircle(const Offset(46, 33), 3.5, Paint()..color = _P.leavesDark);
  }

  void _drawStreetTree(Canvas c) {
    // A single slim, sculpted tree to the right of the entrance.
    final trunk = Path()
      ..moveTo(28, 144)
      ..lineTo(30, 116)
      ..lineTo(34, 116)
      ..lineTo(36, 144)
      ..close();
    c.drawPath(trunk, Paint()..color = _P.trunk);
    c.drawPath(
      trunk,
      Paint()
        ..color = _P.trunkDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
    // Layered foliage — three stacked rounded clouds. Centres sit low
    // enough that the canopy overlaps the trunk top (y=116) instead of
    // floating a few pixels above it ("flying tree" bug).
    final foliage = [
      [const Offset(32, 108), 14.0, _P.leavesDark],
      [const Offset(26, 112), 10.0, _P.leaves],
      [const Offset(38, 114), 9.0, _P.leaves],
      [const Offset(32, 102), 11.0, _P.leavesLight],
    ];
    for (final f in foliage) {
      c.drawCircle(f[0] as Offset, f[1] as double, Paint()..color = f[2] as Color);
    }
    c.drawCircle(
      const Offset(32, 108),
      16,
      Paint()
        ..color = _P.leavesDark.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  @override
  bool shouldRepaint(covariant _ApartmentPainter old) => false;
}

// ─── House painter ─────────────────────────────────────────────────────────

class _HousePainter extends CustomPainter {
  const _HousePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 200.0, size.height / 160.0);
    final dx = (size.width - 200 * scale) / 2;
    final dy = (size.height - 160 * scale) / 2;

    // Hill silhouette + lawn band drawn in pixel space so they reach the
    // full card width on wide layouts.
    _drawFullWidthLandscape(canvas, size, scale, dy);

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    _drawTree(canvas, const Offset(34, 132), 1.0);
    _drawHouseShadow(canvas);
    _drawHouseBody(canvas);
    _drawRoof(canvas);
    _drawChimney(canvas);
    _drawWindows(canvas);
    _drawDoor(canvas);
    _drawPath(canvas);
    _drawTree(canvas, const Offset(174, 132), 0.85);
    _drawShrubs(canvas);

    canvas.restore();

    // Crisp seam between the hill band and the lawn, also full-width.
    canvas.drawLine(
      Offset(0, dy + 122 * scale),
      Offset(size.width, dy + 122 * scale),
      Paint()
        ..color = _P.deepMoss.withValues(alpha: 0.18)
        ..strokeWidth = 0.8,
    );
  }

  void _drawFullWidthLandscape(Canvas c, Size size, double scale, double dy) {
    // Distant hill — same wave shape as before, stretched to the card width.
    final hillBaseY = dy + 124 * scale;
    final hillTopY = dy + 116 * scale;
    final w = size.width;
    final hill = Path()
      ..moveTo(0, hillTopY)
      ..quadraticBezierTo(
          w * 0.30, dy + 96 * scale, w * 0.55, dy + 110 * scale)
      ..quadraticBezierTo(w * 0.80, dy + 122 * scale, w, dy + 104 * scale)
      ..lineTo(w, hillBaseY)
      ..lineTo(0, hillBaseY)
      ..close();
    c.drawPath(
      hill,
      Paint()..color = _P.softJade.withValues(alpha: 0.55),
    );
    // Lawn band running edge-to-edge.
    final lawnTop = dy + 122 * scale;
    final lawnBottom = math.max(size.height, dy + 160 * scale);
    c.drawRect(
      Rect.fromLTWH(0, lawnTop, w, lawnBottom - lawnTop),
      Paint()
        ..shader = LinearGradient(
          colors: const [_P.softJade, _P.frostedSage],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(
          Rect.fromLTWH(0, lawnTop, w, lawnBottom - lawnTop),
        ),
    );
  }

  void _drawHouseShadow(Canvas c) {
    final shadow = RRect.fromRectAndRadius(
      const Rect.fromLTWH(60, 84, 88, 50),
      const Radius.circular(4),
    );
    c.drawRRect(
      shadow.shift(const Offset(2, 4)),
      Paint()
        ..color = _P.deepMoss.withValues(alpha: 0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _drawHouseBody(Canvas c) {
    const wall = Rect.fromLTWH(60, 84, 88, 48);
    final r = RRect.fromRectAndRadius(wall, const Radius.circular(3));
    c.drawRRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.wallTop, _P.wallBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(wall),
    );
    // Right-side shadow ribbon for soft 3D.
    c.drawRect(
      const Rect.fromLTWH(140, 84, 8, 48),
      Paint()..color = _P.wallShade.withValues(alpha: 0.65),
    );
    // Plinth (base trim).
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(58, 128, 92, 5),
        const Radius.circular(1.5),
      ),
      Paint()..color = _P.wallShade,
    );
    c.drawRRect(
      r,
      Paint()
        ..color = _P.mistBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _drawRoof(Canvas c) {
    // Pitched roof with slight overhang.
    final roof = Path()
      ..moveTo(54, 86)
      ..lineTo(104, 50)
      ..lineTo(154, 86)
      ..lineTo(148, 88)
      ..lineTo(104, 56)
      ..lineTo(60, 88)
      ..close();
    c.drawPath(
      roof,
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.roofTop, _P.roofBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(54, 50, 100, 38)),
    );
    // Soft shading on the right slope.
    final shade = Path()
      ..moveTo(104, 50)
      ..lineTo(154, 86)
      ..lineTo(148, 88)
      ..lineTo(104, 56)
      ..close();
    c.drawPath(
      shade,
      Paint()..color = _P.roofTrim.withValues(alpha: 0.18),
    );
    // Subtle horizontal ridges for tile hint.
    final tile = Paint()
      ..color = _P.roofTrim.withValues(alpha: 0.30)
      ..strokeWidth = 0.8;
    for (double y = 60; y < 86; y += 6) {
      final dx = (y - 50) * (50 / 36);
      c.drawLine(Offset(104 - dx, y), Offset(104 + dx, y), tile);
    }
    // Outline.
    c.drawPath(
      roof,
      Paint()
        ..color = _P.roofTrim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawChimney(Canvas c) {
    const rect = Rect.fromLTWH(128, 60, 9, 18);
    c.drawRect(rect, Paint()..color = _P.roofTop);
    c.drawRect(
      const Rect.fromLTWH(128, 60, 9, 4),
      Paint()..color = _P.roofTrim,
    );
    c.drawRect(
      rect,
      Paint()
        ..color = _P.roofTrim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
    // Soft plumes of smoke fading up.
    final smoke = Paint()..color = Colors.white.withValues(alpha: 0.85);
    c.drawCircle(const Offset(135, 56), 3.2, smoke);
    c.drawCircle(const Offset(140, 50), 2.6, smoke);
    c.drawCircle(const Offset(136, 44), 2.0,
        Paint()..color = Colors.white.withValues(alpha: 0.6));
  }

  void _drawWindows(Canvas c) {
    _drawWindow(c, const Rect.fromLTWH(70, 96, 22, 22));
    _drawWindow(c, const Rect.fromLTWH(118, 96, 22, 22));
  }

  void _drawWindow(Canvas c, Rect rect) {
    // Outer frame
    c.drawRRect(
      RRect.fromRectAndRadius(
        rect.inflate(1.2),
        const Radius.circular(3.5),
      ),
      Paint()..color = Colors.white,
    );
    // Glass with warm "lit" gradient.
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2.5)),
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.glassWarm, Color(0xFFF6CB85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );
    // Cross mullions
    final fr = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.4;
    c.drawLine(
      Offset(rect.left + 1, rect.center.dy),
      Offset(rect.right - 1, rect.center.dy),
      fr,
    );
    c.drawLine(
      Offset(rect.center.dx, rect.top + 1),
      Offset(rect.center.dx, rect.bottom - 1),
      fr,
    );
    // Window box / sill
    c.drawRect(
      Rect.fromLTWH(rect.left - 2, rect.bottom + 0.5, rect.width + 4, 2.5),
      Paint()..color = _P.wallShade,
    );
    // Outline
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2.5)),
      Paint()
        ..color = _P.roofTrim.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  void _drawDoor(Canvas c) {
    const door = Rect.fromLTWH(96, 102, 16, 30);
    final r = RRect.fromRectAndCorners(
      door,
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
    );
    c.drawRRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          colors: [_P.doorWarm, _P.door],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(door),
    );
    // Inner panel
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(98.5, 106, 11, 22),
        const Radius.circular(2),
      ),
      Paint()
        ..color = _P.roofTrim.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    // Handle
    c.drawCircle(
      const Offset(106, 118),
      1.3,
      Paint()..color = _P.handle,
    );
    // Outline
    c.drawRRect(
      r,
      Paint()
        ..color = _P.roofTrim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
  }

  void _drawPath(Canvas c) {
    // Trapezoidal stone path leading to the door.
    final p = Path()
      ..moveTo(98, 132)
      ..lineTo(110, 132)
      ..lineTo(126, 160)
      ..lineTo(82, 160)
      ..close();
    c.drawPath(p, Paint()..color = _P.path);
    final stone = Paint()..color = _P.pathDark;
    final stoneOutline = Paint()
      ..color = _P.mistBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (final pos in const [
      Offset(104, 138),
      Offset(101, 146),
      Offset(108, 146),
      Offset(98, 156),
      Offset(110, 156),
    ]) {
      final r = Rect.fromCenter(center: pos, width: 8, height: 4);
      c.drawOval(r, stone);
      c.drawOval(r, stoneOutline);
    }
  }

  void _drawShrubs(Canvas c) {
    void shrub(Offset center, double s) {
      final dark = Paint()..color = _P.leavesDark;
      final mid = Paint()..color = _P.leaves;
      final light = Paint()..color = _P.leavesLight;
      c.drawCircle(center.translate(-3 * s, 0), 4.5 * s, dark);
      c.drawCircle(center.translate(3 * s, 0), 4.5 * s, dark);
      c.drawCircle(center.translate(0, -2 * s), 5 * s, mid);
      c.drawCircle(center.translate(-1.5 * s, -3 * s), 2.5 * s, light);
    }

    shrub(const Offset(70, 132), 1.0);
    shrub(const Offset(140, 132), 1.0);
  }

  void _drawTree(Canvas c, Offset baseCenter, double scale) {
    final trunkW = 4.5 * scale;
    final trunkH = 26 * scale;
    final trunkRect = Rect.fromCenter(
      center: Offset(baseCenter.dx, baseCenter.dy - trunkH / 2),
      width: trunkW,
      height: trunkH,
    );
    c.drawRect(trunkRect, Paint()..color = _P.trunk);
    c.drawRect(
      trunkRect,
      Paint()
        ..color = _P.trunkDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    final foliageCenter = Offset(baseCenter.dx, baseCenter.dy - trunkH - 2);
    final r1 = 16 * scale;
    final r2 = 11 * scale;
    final r3 = 9 * scale;
    c.drawCircle(foliageCenter, r1, Paint()..color = _P.leavesDark);
    c.drawCircle(
      foliageCenter.translate(-6 * scale, 4 * scale),
      r2,
      Paint()..color = _P.leaves,
    );
    c.drawCircle(
      foliageCenter.translate(6 * scale, 4 * scale),
      r3,
      Paint()..color = _P.leaves,
    );
    c.drawCircle(
      foliageCenter.translate(-2 * scale, -4 * scale),
      r3,
      Paint()..color = _P.leavesLight,
    );
    c.drawCircle(
      foliageCenter,
      r1 + 1,
      Paint()
        ..color = _P.leavesDark.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  @override
  bool shouldRepaint(covariant _HousePainter old) => false;
}
