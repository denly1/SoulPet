import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer 0 — painted room background
          const Positioned.fill(child: _RoomBackground()),
          // Layer 1 — full UI
          SafeArea(child: _buildUI(context)),
        ],
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        // ── Top status bar ──
        _buildStatusBar(),
        // ── Pet in room (expands to fill available space) ──
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Floating cat with pillow
              Positioned(
                bottom: size.height * 0.10,
                child: AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _floatAnim.value),
                    child: const _CatOnPillow(),
                  ),
                ),
              ),
              // Sparkle ring around buttons area (decorative)
              Positioned(
                bottom: size.height * 0.02,
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
        // ── Big paw pill button ──
        _buildPawButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Top status bar: time | balance | mail | weather ──
  Widget _buildStatusBar() {
    final now = DateTime.now();
    final timeStr = DateFormat('HH:mm').format(now);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          // Time
          LiquidGlassPill(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              timeStr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Balance
          LiquidGlassPill(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.pets_rounded, size: 14, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  'Баланс 423',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Mail
          LiquidGlassPill(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.mail_outline_rounded,
                    size: 15, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  '2°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Weather
          LiquidGlassPill(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.thunderstorm_outlined,
                    size: 15, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  '19°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 5 circular action buttons ──
  Widget _buildActionButtons() {
    final buttons = [
      _ActionBtn(Icons.extension_rounded, 'Games', () {}),
      _ActionBtn(Icons.pets_rounded, 'Buddy', () {}),
      _ActionBtn(Icons.smart_toy_rounded, 'AI Chat', () {}),
      _ActionBtn(Icons.restaurant_rounded, 'Food', () {}),
      _ActionBtn(Icons.shopping_bag_outlined, 'Shop', () {}),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((btn) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: btn.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlassCircle(
                  size: 62,
                  child: Icon(btn.icon,
                      size: 26, color: AppColors.deepMoss),
                ),
                const SizedBox(height: 6),
                Text(
                  btn.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(color: Colors.black38, blurRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Big paw pill at the very bottom ──
  Widget _buildPawButton() {
    return GestureDetector(
      onTap: () {},
      child: LiquidGlassPill(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        child: Icon(Icons.pets_rounded,
            size: 32, color: AppColors.deepMoss),
      ),
    );
  }
}

class _ActionBtn {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn(this.icon, this.label, this.onTap);
}

// ── Painted room background ─────────────────────────────────────────────────

class _RoomBackground extends StatelessWidget {
  const _RoomBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoomPainter(),
      child: Container(),
    );
  }
}

class _RoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Sky / ceiling gradient ──
    final ceilingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE8F0E8), Color(0xFFD0E4D0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.55));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.55), ceilingPaint);

    // ── Floor (warm parquet) ──
    final floorPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8B5E3C), Color(0xFF6B4226), Color(0xFF5C3317)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, h * 0.55, w, h * 0.45));
    canvas.drawRect(
        Rect.fromLTWH(0, h * 0.55, w, h * 0.45), floorPaint);

    // Floor planks
    final plankPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1.2;
    for (int i = 0; i < 12; i++) {
      final y = h * 0.55 + (h * 0.45 / 12) * i;
      canvas.drawLine(Offset(0, y), Offset(w, y), plankPaint);
    }

    // ── Ceiling light bar ──
    final lightPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFEAA0), Color(0xFFFFF5D0), Color(0xFFFFEAA0)],
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.03, w * 0.6, 10));
    final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.03, w * 0.6, 10),
        const Radius.circular(5));
    canvas.drawRRect(rrect, lightPaint);
    // Glow
    final glowPaint = Paint()
      ..color = const Color(0x30FFE87A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.1, 0, w * 0.8, 60),
            const Radius.circular(30)),
        glowPaint);

    // ── Window (right side) ──
    _drawWindow(canvas, Rect.fromLTWH(w * 0.52, h * 0.07, w * 0.42, h * 0.40));

    // ── Bookshelf (left side) ──
    _drawBookshelf(canvas, size);

    // ── Left plant ──
    _drawPlant(canvas, Offset(w * 0.28, h * 0.56), 1.0, size);

    // ── Right plant / table ──
    _drawSmallPlant(canvas, Offset(w * 0.86, h * 0.52), size);

    // ── White rug circle ──
    final rugPaint = Paint()
      ..color = const Color(0xDDFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.70),
            width: w * 0.72,
            height: h * 0.18),
        rugPaint);
    // Rug shadow edge
    final rugEdge = Paint()
      ..color = const Color(0x18A0C0A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.70),
            width: w * 0.72,
            height: h * 0.18),
        rugEdge);
  }

  void _drawWindow(Canvas canvas, Rect rect) {
    // Sky outside window
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFFB0E0B0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // Green trees outside
    final treePaint = Paint()..color = const Color(0xFF5A9A5A);
    final rng = math.Random(7);
    for (int i = 0; i < 5; i++) {
      final cx = rect.left + rect.width * (0.1 + i * 0.2);
      final cy = rect.bottom - rect.height * 0.15;
      final r = rect.width * (0.06 + rng.nextDouble() * 0.07);
      canvas.drawCircle(Offset(cx, cy), r, treePaint);
    }

    // Window frame
    final framePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawRect(rect, framePaint);
    // Curtains
    final curtainPaint = Paint()..color = const Color(0xEEF8F8F8);
    final leftCurtain = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + rect.width * 0.22, rect.top)
      ..quadraticBezierTo(
          rect.left + rect.width * 0.15,
          rect.top + rect.height * 0.5,
          rect.left + rect.width * 0.18,
          rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(leftCurtain, curtainPaint);
    final rightCurtain = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right - rect.width * 0.22, rect.top)
      ..quadraticBezierTo(
          rect.right - rect.width * 0.15,
          rect.top + rect.height * 0.5,
          rect.right - rect.width * 0.18,
          rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(rightCurtain, curtainPaint);
  }

  void _drawBookshelf(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final left = w * 0.0;
    final top = h * 0.08;
    final shelfW = w * 0.30;
    final shelfH = h * 0.46;

    // Shelf body
    final shelfPaint = Paint()..color = const Color(0xFFF0F0F0);
    canvas.drawRect(Rect.fromLTWH(left, top, shelfW, shelfH), shelfPaint);

    // Shelves
    final linePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 4;
    for (int i = 1; i < 4; i++) {
      final y = top + shelfH * (i / 4);
      canvas.drawLine(Offset(left, y), Offset(left + shelfW, y), linePaint);
    }

    // Books
    final bookColors = [
      const Color(0xFF7EC8A0),
      const Color(0xFF9FB8D8),
      const Color(0xFFD8A07E),
      const Color(0xFFB8D89F),
      const Color(0xFFD8C07E),
      const Color(0xFF8FB8C8),
    ];
    final rng = math.Random(11);
    for (int shelf = 0; shelf < 3; shelf++) {
      final shelfY = top + shelfH * (shelf / 4) + 4;
      final shelfBottom = top + shelfH * ((shelf + 1) / 4);
      double bx = left + 4;
      int bi = 0;
      while (bx < left + shelfW - 8 && bi < 8) {
        final bw = 10.0 + rng.nextDouble() * 8;
        final bh = shelfBottom - shelfY - 6;
        final bp = Paint()
          ..color = bookColors[(shelf * 3 + bi) % bookColors.length];
        canvas.drawRect(Rect.fromLTWH(bx, shelfY, bw, bh), bp);
        bx += bw + 2;
        bi++;
      }
    }

    // Small plant on top shelf
    final potP = Paint()..color = const Color(0xFFD4A574);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(left + shelfW * 0.65, top + 4, 20, 20),
            bottomLeft: const Radius.circular(4),
            bottomRight: const Radius.circular(4)),
        potP);
    final leafP = Paint()..color = const Color(0xFF5AAA70);
    canvas.drawCircle(
        Offset(left + shelfW * 0.65 + 10, top + 2), 12, leafP);
  }

  void _drawPlant(
      Canvas canvas, Offset base, double scale, Size size) {
    // Pot
    final potPaint = Paint()..color = const Color(0xFFE8E8E8);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(base.dx, base.dy - 10 * scale),
                width: 44 * scale,
                height: 40 * scale),
            const Radius.circular(6)),
        potPaint);

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF5A8A3A)
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(base.translate(0, -30 * scale),
        base.translate(0, -90 * scale), stemPaint);

    // Leaves
    final leafPaint = Paint()..color = const Color(0xFF5AAA60);
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + (i - 2) * 0.45;
      final len = 45 * scale;
      final cx = base.dx + math.cos(angle) * len * 0.5;
      final cy = base.dy - 70 * scale + math.sin(angle) * len * 0.5;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx, cy),
              width: 30 * scale,
              height: 16 * scale),
          leafPaint);
    }
  }

  void _drawSmallPlant(Canvas canvas, Offset base, Size size) {
    // Table
    final tablePaint = Paint()..color = const Color(0xFFF0F0F0);
    canvas.drawRect(
        Rect.fromLTWH(base.dx - 28, base.dy, 56, 10), tablePaint);
    canvas.drawRect(
        Rect.fromLTWH(base.dx - 24, base.dy + 10, 8, 30), tablePaint);
    canvas.drawRect(
        Rect.fromLTWH(base.dx + 16, base.dy + 10, 8, 30), tablePaint);
    // Pot
    final potPaint = Paint()..color = const Color(0xFFE8E8E8);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(base.dx - 14, base.dy - 32, 28, 32),
            const Radius.circular(4)),
        potPaint);
    // Leaves
    final leafPaint = Paint()..color = const Color(0xFF5AAA60);
    for (int i = 0; i < 4; i++) {
      final angle = -math.pi / 2 + (i - 1.5) * 0.6;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(
                  base.dx + math.cos(angle) * 22,
                  base.dy - 40 + math.sin(angle) * 14),
              width: 24,
              height: 14),
          leafPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Cat on pillow ─────────────────────────────────────────────────────────

class _CatOnPillow extends StatelessWidget {
  const _CatOnPillow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 180),
      painter: _CatPainter(),
    );
  }
}

class _CatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.58;

    // ── Pillow (green donut cushion) ──
    final pillowOuter = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFA8D8A8),
          const Color(0xFF88C488),
          const Color(0xFF6AAA6A),
        ],
        center: Alignment.topCenter,
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy + 20), width: 180, height: 80));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 20), width: 175, height: 60),
        pillowOuter);
    // Pillow inner hole / shadow
    final pillowInner = Paint()..color = const Color(0x4055885A);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 22), width: 90, height: 28),
        pillowInner);
    // Pillow highlight
    final pillowHL = Paint()
      ..color = const Color(0x55FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 14), width: 140, height: 28),
        pillowHL);

    // ── Cat body ──
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFF5C88A), const Color(0xFFE8A866)],
        center: const Alignment(-0.3, -0.5),
      ).createShader(
          Rect.fromCenter(center: Offset(cx, cy - 20), width: 90, height: 80));
    // Body oval
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy - 14), width: 72, height: 68),
        bodyPaint);

    // ── Cat head ──
    canvas.drawCircle(Offset(cx, cy - 58), 38, bodyPaint);

    // Ears
    _drawEar(canvas, Offset(cx - 24, cy - 88), -0.4, bodyPaint);
    _drawEar(canvas, Offset(cx + 24, cy - 88), 0.4, bodyPaint);

    // Inner ears
    final innerEarPaint = Paint()..color = const Color(0xFFFFB6C1);
    _drawEar(canvas, Offset(cx - 24, cy - 88), -0.4, innerEarPaint,
        scale: 0.55);
    _drawEar(canvas, Offset(cx + 24, cy - 88), 0.4, innerEarPaint,
        scale: 0.55);

    // ── Face ──
    // Eyes (green)
    final eyePaint = Paint()..color = const Color(0xFF5DC0A0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - 12, cy - 60), width: 16, height: 14),
        eyePaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + 12, cy - 60), width: 16, height: 14),
        eyePaint);
    // Pupils
    final pupilPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx - 12, cy - 60), width: 7, height: 12),
        pupilPaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx + 12, cy - 60), width: 7, height: 12),
        pupilPaint);
    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 9, cy - 63), 3, shinePaint);
    canvas.drawCircle(Offset(cx + 15, cy - 63), 3, shinePaint);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFFFFB6C1);
    final nosePath = Path()
      ..moveTo(cx, cy - 49)
      ..lineTo(cx - 5, cy - 45)
      ..lineTo(cx + 5, cy - 45)
      ..close();
    canvas.drawPath(nosePath, nosePaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4040)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final mouthPath = Path()
      ..moveTo(cx - 8, cy - 42)
      ..quadraticBezierTo(cx, cy - 38, cx + 8, cy - 42);
    canvas.drawPath(mouthPath, mouthPaint);

    // Whiskers
    final whiskerPaint = Paint()
      ..color = const Color(0x99FFFFFF)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (final side in [-1.0, 1.0]) {
      for (int i = 0; i < 3; i++) {
        final y = cy - 48 + i * 4.0;
        canvas.drawLine(
            Offset(cx + side * 8, y),
            Offset(cx + side * 35, y - 3 + i * 3),
            whiskerPaint);
      }
    }

    // Tail
    final tailPaint = Paint()
      ..color = const Color(0xFFE8A866)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final tailPath = Path()
      ..moveTo(cx + 28, cy + 10)
      ..quadraticBezierTo(cx + 70, cy + 30, cx + 55, cy - 10);
    canvas.drawPath(tailPath, tailPaint);

    // ── Sparkle dots around pillow ──
    final sparklePaint = Paint()..color = const Color(0xAAFFFFFF);
    final rng = math.Random(3);
    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi * 2 / 12;
      final r = 90.0 + rng.nextDouble() * 14;
      final sx = cx + math.cos(angle) * r;
      final sy = (cy + 20) + math.sin(angle) * 36;
      canvas.drawCircle(Offset(sx, sy), 1.5 + rng.nextDouble() * 2,
          sparklePaint);
    }
  }

  void _drawEar(Canvas canvas, Offset tip, double tilt, Paint paint,
      {double scale = 1.0}) {
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - 16 * scale, tip.dy + 26 * scale)
      ..lineTo(tip.dx + 16 * scale, tip.dy + 26 * scale)
      ..close();
    canvas.save();
    canvas.translate(tip.dx, tip.dy);
    canvas.rotate(tilt * 0.15);
    canvas.translate(-tip.dx, -tip.dy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
