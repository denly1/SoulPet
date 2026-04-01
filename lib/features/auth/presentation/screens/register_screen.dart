import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/core/utils/validators.dart';
import 'package:soulpet/domain/usecases/auth/register_usecase.dart';
import 'package:soulpet/shared/widgets/sp_snackbar.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await sl<RegisterUseCase>().call(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (failure) => SpSnackbar.show(context, failure.message, isError: true),
      (tokens) => context.go(AppRoutes.home),
    );
  }

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Room background ──
          Positioned.fill(
            child: CustomPaint(painter: _AuthRoomPainter()),
          ),
          // ── UI ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Paw glass circle
                    LiquidGlassCircle(
                      size: 64,
                      child: Icon(Icons.pets_rounded,
                          size: 30, color: AppColors.deepMoss),
                    ),
                    const SizedBox(height: 0),
                    // Glass form card
                    LiquidGlassCard(
                      borderRadius: 28,
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        children: [
                          // Soul Pet title
                          Text(
                            'Soul Pet',
                            style: TextStyle(
                              color: AppColors.deepMoss,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Name field
                          _GlassField(
                            controller: _usernameController,
                            hint: 'Enter your name',
                            validator: Validators.username,
                            prefixIcon: Icons.pets_rounded,
                            suffixIcon: Icons.pets_outlined,
                          ),
                          const SizedBox(height: 12),
                          // Email field
                          _GlassField(
                            controller: _emailController,
                            hint: 'Enter your email',
                            validator: Validators.email,
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          // Password field
                          _GlassField(
                            controller: _passwordController,
                            hint: 'Password',
                            validator: Validators.password,
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          const SizedBox(height: 20),
                          // Sign Up button
                          GestureDetector(
                            onTap: _loading ? null : _register,
                            child: LiquidGlassPill(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 14),
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: _loading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: AppColors.deepMoss,
                                          ),
                                        )
                                      : Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: AppColors.deepMoss,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: AppColors.deepMoss,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Pet on pillow (floating)
                    AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, _floatAnim.value),
                        child: CustomPaint(
                          size: const Size(180, 160),
                          painter: _PetOnPillowPainter(isCat: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // OR divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.5),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                              shadows: const [
                                Shadow(color: Colors.black26, blurRadius: 4)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.5),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.facebook_rounded,
                          color: const Color(0xFF1877F2),
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          color: const Color(0xFFEA4335),
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.apple_rounded,
                          color: Colors.black87,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign up with',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        shadows: const [
                          Shadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glass input field ────────────────────────────────────────────────────────

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;

  const _GlassField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.validator,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassPill(
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textHint,
            fontSize: 15,
          ),
          prefixIcon: Icon(prefixIcon, color: AppColors.textHint, size: 20),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(suffixIcon, color: AppColors.textHint, size: 20),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ── Social button ────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassPill(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}

// ── Auth room background (lighter, blurrier version) ─────────────────────────

class _AuthRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base gradient (light, airy)
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE8F0E8), Color(0xFFD8ECD8), Color(0xFFEEF5EE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Floor
    final floorPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF9B6E47), Color(0xFF7A5230)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.6, w, h * 0.4), floorPaint);

    // Floor planks
    final plankP = Paint()
      ..color = const Color(0x18000000)
      ..strokeWidth = 1;
    for (int i = 0; i < 10; i++) {
      final y = h * 0.6 + (h * 0.4 / 10) * i;
      canvas.drawLine(Offset(0, y), Offset(w, y), plankP);
    }

    // Ceiling light glow
    final glowP = Paint()
      ..color = const Color(0x30FFE87A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.5, h * 0.02), width: w * 0.7, height: 80),
        glowP);
    final lightBar = Paint()
      ..color = const Color(0xCCFFF5C0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, h * 0.025, w * 0.6, 8),
            const Radius.circular(4)),
        lightBar);

    // Window (right)
    _drawWindow(canvas,
        Rect.fromLTWH(w * 0.55, h * 0.07, w * 0.40, h * 0.38));

    // Bookshelf (left, partial)
    _drawShelf(canvas, size);

    // Right plant
    _drawPlant(canvas, Offset(w * 0.88, h * 0.55), size);

    // Rug
    final rugP = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.5, h * 0.73),
            width: w * 0.75,
            height: h * 0.15),
        rugP);

    // Sparkle overlay dots
    final sparkP = Paint()..color = const Color(0x55FFFFFF);
    final rng = math.Random(17);
    for (int i = 0; i < 24; i++) {
      canvas.drawCircle(
          Offset(rng.nextDouble() * w, rng.nextDouble() * h),
          1 + rng.nextDouble() * 2.5,
          sparkP);
    }
  }

  void _drawWindow(Canvas canvas, Rect rect) {
    final skyP = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFFB8E4A8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, skyP);
    final treeP = Paint()..color = const Color(0xFF5A9A5A);
    final rng = math.Random(5);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
          Offset(rect.left + rect.width * (0.1 + i * 0.2),
              rect.bottom - rect.height * 0.12),
          rect.width * (0.06 + rng.nextDouble() * 0.06),
          treeP);
    }
    final frameP = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    canvas.drawRect(rect, frameP);
    final curtainP = Paint()..color = const Color(0xEEF8F8F8);
    final lc = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + rect.width * 0.2, rect.top)
      ..quadraticBezierTo(rect.left + rect.width * 0.13,
          rect.top + rect.height * 0.5, rect.left + rect.width * 0.16, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(lc, curtainP);
    final rc = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right - rect.width * 0.2, rect.top)
      ..quadraticBezierTo(rect.right - rect.width * 0.13,
          rect.top + rect.height * 0.5, rect.right - rect.width * 0.16, rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(rc, curtainP);
  }

  void _drawShelf(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shelfP = Paint()..color = const Color(0xFFF2F2F2);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.08, w * 0.28, h * 0.44), shelfP);
    final lineP = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 3;
    for (int i = 1; i < 4; i++) {
      final y = h * 0.08 + h * 0.44 * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w * 0.28, y), lineP);
    }
    final bookColors = [
      const Color(0xFF7EC8A0), const Color(0xFF9FB8D8),
      const Color(0xFFD8A07E), const Color(0xFFB8D89F),
      const Color(0xFFD8C07E), const Color(0xFF8FB8C8),
    ];
    final rng = math.Random(9);
    for (int shelf = 0; shelf < 3; shelf++) {
      final sy = h * 0.08 + h * 0.44 * (shelf / 4) + 3;
      final sb = h * 0.08 + h * 0.44 * ((shelf + 1) / 4);
      double bx = 2;
      int bi = 0;
      while (bx < w * 0.28 - 6 && bi < 7) {
        final bw = 9.0 + rng.nextDouble() * 7;
        canvas.drawRect(
            Rect.fromLTWH(bx, sy, bw, sb - sy - 4),
            Paint()..color = bookColors[(shelf * 3 + bi) % bookColors.length]);
        bx += bw + 2;
        bi++;
      }
    }
  }

  void _drawPlant(Canvas canvas, Offset base, Size size) {
    final potP = Paint()..color = const Color(0xFFE8E8E8);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: base, width: 36, height: 34),
            const Radius.circular(5)),
        potP);
    final stemP = Paint()
      ..color = const Color(0xFF5A8A3A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        base.translate(0, -17), base.translate(0, -65), stemP);
    final leafP = Paint()..color = const Color(0xFF5AAA60);
    for (int i = 0; i < 4; i++) {
      final angle = -math.pi / 2 + (i - 1.5) * 0.5;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(base.dx + math.cos(angle) * 22,
                  base.dy - 50 + math.sin(angle) * 12),
              width: 26,
              height: 13),
          leafP);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Pet on pillow painter (reusable) ─────────────────────────────────────────

class _PetOnPillowPainter extends CustomPainter {
  final bool isCat;
  const _PetOnPillowPainter({this.isCat = true});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;

    // Pillow
    final pillowP = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFA8D8A8), const Color(0xFF6AAA6A)],
        center: Alignment.topCenter,
      ).createShader(
          Rect.fromCenter(center: Offset(cx, cy + 18), width: 160, height: 60));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 18), width: 158, height: 52),
        pillowP);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 20), width: 80, height: 24),
        Paint()..color = const Color(0x3855885A));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 12), width: 120, height: 22),
        Paint()
          ..color = const Color(0x44FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);

    // Body color
    final bodyColor =
        isCat ? const Color(0xFFF5C88A) : const Color(0xFFF5DFA0);
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [bodyColor, Color.lerp(bodyColor, Colors.brown, 0.25)!],
        center: const Alignment(-0.3, -0.5),
      ).createShader(
          Rect.fromCenter(center: Offset(cx, cy - 18), width: 80, height: 70));

    // Body
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - 12), width: 64, height: 58),
        bodyPaint);
    // Head
    canvas.drawCircle(Offset(cx, cy - 52), 34, bodyPaint);

    if (isCat) {
      // Cat ears
      _drawTriangle(canvas, Offset(cx - 22, cy - 80), bodyPaint, false);
      _drawTriangle(canvas, Offset(cx + 22, cy - 80), bodyPaint, true);
      _drawTriangle(
          canvas, Offset(cx - 22, cy - 80),
          Paint()..color = const Color(0xFFFFB6C1), false,
          scale: 0.55);
      _drawTriangle(
          canvas, Offset(cx + 22, cy - 80),
          Paint()..color = const Color(0xFFFFB6C1), true,
          scale: 0.55);
    } else {
      // Dog floppy ears
      final earP = Paint()..color = Color.lerp(bodyColor, Colors.brown, 0.3)!;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx - 36, cy - 46), width: 22, height: 36),
          earP);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + 36, cy - 46), width: 22, height: 36),
          earP);
    }

    // Eyes
    final eyeColor =
        isCat ? const Color(0xFF5DC0A0) : const Color(0xFF3A2A1A);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 11, cy - 54), width: 14, height: 12),
        Paint()..color = eyeColor);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 11, cy - 54), width: 14, height: 12),
        Paint()..color = eyeColor);
    // Pupils
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 11, cy - 54), width: 6, height: 10),
        Paint()..color = const Color(0xFF1A1A2E));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 11, cy - 54), width: 6, height: 10),
        Paint()..color = const Color(0xFF1A1A2E));
    // Shine
    canvas.drawCircle(Offset(cx - 8, cy - 57), 2.5, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx + 14, cy - 57), 2.5, Paint()..color = Colors.white);

    // Nose
    final nosePath = Path()
      ..moveTo(cx, cy - 43)
      ..lineTo(cx - 4, cy - 40)
      ..lineTo(cx + 4, cy - 40)
      ..close();
    canvas.drawPath(nosePath, Paint()..color = const Color(0xFFFFB6C1));

    // Mouth
    final mouthP = Paint()
      ..color = const Color(0xFF8B4040)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
        Path()
          ..moveTo(cx - 7, cy - 37)
          ..quadraticBezierTo(cx, cy - 33, cx + 7, cy - 37),
        mouthP);

    // Collar (teal with heart)
    final collarP = Paint()..color = const Color(0xFF7EC8B0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(cx, cy - 18), width: 50, height: 8),
            const Radius.circular(4)),
        collarP);
    // Heart charm
    canvas.drawCircle(
        Offset(cx, cy - 12), 5,
        Paint()..color = const Color(0xFFFFD700));

    // Sparkles around pillow
    final sparkP = Paint()..color = const Color(0xAAFFFFFF);
    final rng = math.Random(5);
    for (int i = 0; i < 10; i++) {
      final angle = i * math.pi * 2 / 10;
      final r = 82.0 + rng.nextDouble() * 10;
      canvas.drawCircle(
          Offset(cx + math.cos(angle) * r, (cy + 18) + math.sin(angle) * 30),
          1.5 + rng.nextDouble() * 1.5,
          sparkP);
    }
  }

  void _drawTriangle(Canvas canvas, Offset tip, Paint paint, bool flipX,
      {double scale = 1.0}) {
    final dx = flipX ? 14.0 * scale : -14.0 * scale;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - dx, tip.dy + 24 * scale)
      ..lineTo(tip.dx + dx, tip.dy + 24 * scale)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
