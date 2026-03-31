import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final authDatasource = sl<AuthLocalDatasource>();
    final isLoggedIn = await authDatasource.hasValidSession();
    final isOnboardingDone = await authDatasource.isOnboardingDone();

    if (!mounted) return;

    if (!isOnboardingDone) {
      context.go(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: Stack(
          children: [
            ..._buildBubbles(),
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glass logo
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: LiquidGlassCircle(
                          size: 140,
                          child: Icon(Icons.spa_rounded,
                              size: 64, color: AppColors.deepMoss),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Soulpet',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Спокойный AI-компаньон',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: AppColors.deepMoss.withValues(alpha: 0.5),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBubbles() {
    final rng = Random(42);
    final screen = MediaQuery.of(context).size;
    return List.generate(10, (i) {
      final size = 20.0 + rng.nextDouble() * 70;
      final top = rng.nextDouble() * screen.height;
      final left = rng.nextDouble() * screen.width;
      return Positioned(
        top: top,
        left: left,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.softJade.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
        ),
      );
    });
  }
}
