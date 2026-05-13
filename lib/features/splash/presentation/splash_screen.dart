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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  late AnimationController _textController;
  late Animation<double> _t1Fade;
  late Animation<double> _t2Fade;
  late Animation<double> _t3Fade;

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

    // Text sequence: 0.8s delay + 1.5s each line (total 5.3s)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5300),
    );

    const delayEnd = 0.15;  // 800/5300 initial delay
    const t1End = 0.434;    // (800+1500)/5300
    const t2End = 0.717;    // (800+3000)/5300
    const t3End = 1.0;      // (800+4500)/5300

    _t1Fade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(delayEnd, t1End, curve: Curves.easeOut),
    );
    _t2Fade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(t1End, t2End, curve: Curves.easeOut),
    );
    _t3Fade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(t2End, t3End, curve: Curves.easeOut),
    );


    _textController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 5500));
    if (!mounted) return;

    final authDatasource = sl<AuthLocalDatasource>();
    final isOnboardingDone = await authDatasource.isOnboardingDone();

    // Always clear session on app start — user must login every time
    await authDatasource.clearTokens();

    if (!mounted) return;

    if (!isOnboardingDone) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
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
                      const SizedBox(height: 36),
                      Text(
                        'Soulpet',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _t1Fade,
                            child: Text(
                              'Персональный',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          FadeTransition(
                            opacity: _t2Fade,
                            child: Text(
                              'Эксклюзивный',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          FadeTransition(
                            opacity: _t3Fade,
                            child: Text(
                              'Твой уникальный AI-компаньон',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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

}
