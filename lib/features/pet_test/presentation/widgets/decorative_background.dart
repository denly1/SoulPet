import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';

/// Floating decorative shapes in the background — sparkles and soft paw prints.
/// Gently drift and rotate. Purely visual; ignores pointer events.
class DecorativeBackground extends StatefulWidget {
  final Widget child;
  final int sparkleCount;
  final int pawCount;
  const DecorativeBackground({
    super.key,
    required this.child,
    this.sparkleCount = 14,
    this.pawCount = 5,
  });

  @override
  State<DecorativeBackground> createState() => _DecorativeBackgroundState();
}

class _DecorativeBackgroundState extends State<DecorativeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Sparkle> _sparkles;
  late final List<_Paw> _paws;
  final _rand = math.Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _sparkles = List.generate(widget.sparkleCount, (_) => _Sparkle.random(_rand));
    _paws = List.generate(widget.pawCount, (_) => _Paw.random(_rand));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _DecoPainter(
                  t: _controller.value,
                  sparkles: _sparkles,
                  paws: _paws,
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Sparkle {
  final double x, y, size, speed, phase;
  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
  factory _Sparkle.random(math.Random r) => _Sparkle(
        x: r.nextDouble(),
        y: r.nextDouble(),
        size: 3 + r.nextDouble() * 5,
        speed: 0.3 + r.nextDouble() * 0.7,
        phase: r.nextDouble() * math.pi * 2,
      );
}

class _Paw {
  final double x, y, size, rotation, speed, phase;
  _Paw({
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.speed,
    required this.phase,
  });
  factory _Paw.random(math.Random r) => _Paw(
        x: r.nextDouble(),
        y: r.nextDouble(),
        size: 14 + r.nextDouble() * 10,
        rotation: (r.nextDouble() - 0.5) * math.pi * 0.6,
        speed: 0.2 + r.nextDouble() * 0.4,
        phase: r.nextDouble() * math.pi * 2,
      );
}

class _DecoPainter extends CustomPainter {
  final double t;
  final List<_Sparkle> sparkles;
  final List<_Paw> paws;
  _DecoPainter({required this.t, required this.sparkles, required this.paws});

  @override
  void paint(Canvas canvas, Size size) {
    // Sparkles
    for (final s in sparkles) {
      final progress = (t * s.speed + s.phase) % 1;
      final dy = (progress * size.height) - 20;
      final x = s.x * size.width +
          math.sin(progress * math.pi * 2) * 18;
      final alpha = (math.sin(progress * math.pi) * 0.6).clamp(0.0, 1.0);
      _drawSparkle(
        canvas,
        Offset(x, dy),
        s.size,
        AppColors.deepMoss.withValues(alpha: alpha * 0.35),
      );
    }

    // Paw prints
    for (final p in paws) {
      final progress = (t * p.speed + p.phase) % 1;
      final dy = (progress * (size.height + 100)) - 50;
      final alpha = (math.sin(progress * math.pi) * 0.5).clamp(0.0, 1.0);
      canvas.save();
      canvas.translate(p.x * size.width, dy);
      canvas.rotate(p.rotation);
      _drawPaw(
        canvas,
        p.size,
        AppColors.liquidGreen.withValues(alpha: alpha * 0.18),
      );
      canvas.restore();
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, double s, Color color) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(c.dx, c.dy - s)
      ..quadraticBezierTo(c.dx + s * 0.25, c.dy - s * 0.25, c.dx + s, c.dy)
      ..quadraticBezierTo(c.dx + s * 0.25, c.dy + s * 0.25, c.dx, c.dy + s)
      ..quadraticBezierTo(c.dx - s * 0.25, c.dy + s * 0.25, c.dx - s, c.dy)
      ..quadraticBezierTo(c.dx - s * 0.25, c.dy - s * 0.25, c.dx, c.dy - s)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawPaw(Canvas canvas, double size, Color color) {
    final paint = Paint()..color = color;
    // Main pad
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, size * 0.25),
        width: size * 0.75,
        height: size * 0.6,
      ),
      paint,
    );
    // Toes
    final toeW = size * 0.28;
    final toeH = size * 0.34;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-size * 0.35, -size * 0.15),
        width: toeW,
        height: toeH,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-size * 0.1, -size * 0.38),
        width: toeW,
        height: toeH,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size * 0.18, -size * 0.36),
        width: toeW,
        height: toeH,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size * 0.4, -size * 0.1),
        width: toeW,
        height: toeH,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DecoPainter old) => old.t != t;
}

/// One-shot confetti burst used on the result screen.
class ConfettiBurst extends StatefulWidget {
  final Duration duration;
  final int count;
  const ConfettiBurst({
    super.key,
    this.duration = const Duration(milliseconds: 1800),
    this.count = 40,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _rand = math.Random();

  static const _colors = [
    Color(0xFFF4A261),
    Color(0xFFE76F51),
    Color(0xFF6F9B84),
    Color(0xFFB9DCC7),
    Color(0xFFE9C46A),
    Color(0xFFF0A6A0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
    _particles = List.generate(widget.count, (_) {
      final angle = _rand.nextDouble() * math.pi * 2;
      final speed = 120 + _rand.nextDouble() * 180;
      return _Particle(
        angle: angle,
        speed: speed,
        color: _colors[_rand.nextInt(_colors.length)],
        size: 5 + _rand.nextDouble() * 5,
        rotation: _rand.nextDouble() * math.pi * 2,
        rotationSpeed: (_rand.nextDouble() - 0.5) * 8,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              t: _controller.value,
              particles: _particles,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotation;
  final double rotationSpeed;
  _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  final List<_Particle> particles;
  _ConfettiPainter({required this.t, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);
    final gravity = 420.0;
    for (final p in particles) {
      final dx = math.cos(p.angle) * p.speed * t;
      final dy = math.sin(p.angle) * p.speed * t + 0.5 * gravity * t * t;
      final pos = center + Offset(dx, dy);
      final alpha = (1 - t).clamp(0.0, 1.0);
      final paint = Paint()..color = p.color.withValues(alpha: alpha);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotation + p.rotationSpeed * t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
