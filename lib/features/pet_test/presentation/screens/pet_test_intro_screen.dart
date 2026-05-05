import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/pet_illustrations.dart';
import 'package:soulpet/shared/widgets/lang_toggle.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// Welcome screen for the pet-creation test. Soft, animated and reassuring —
/// a cat + dog side by side bob gently while sparkles drift in the background.
class PetTestIntroScreen extends StatefulWidget {
  const PetTestIntroScreen({super.key});

  @override
  State<PetTestIntroScreen> createState() => _PetTestIntroScreenState();
}

class _PetTestIntroScreenState extends State<PetTestIntroScreen> {
  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  Future<void> _startTest(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await PetTestStorage(prefs).clearAll();
    if (!context.mounted) return;
    context.go(AppRoutes.petTest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildHero(),
                      ),
                      _buildActions(context),
                    ],
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 24,
                  child: LangToggle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.canPop() ? context.pop() : null,
          child: LiquidGlassCircle(
            size: 42,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.deepMoss,
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).moveX(begin: -12, end: 0),
        const Spacer(),
      ],
    );
  }

  Widget _buildHero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final petSize = (constraints.maxWidth * 0.42).clamp(130.0, 180.0);
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                S.petTestIntroTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
              )
                  .animate()
                  .fadeIn(delay: 120.ms, duration: 550.ms)
                  .moveY(begin: 18, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  S.petTestIntroSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 260.ms, duration: 550.ms)
                  .moveY(begin: 12, end: 0),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedPet(isCat: true, size: petSize)
                      .animate()
                      .fadeIn(delay: 380.ms, duration: 600.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                        duration: 900.ms,
                      ),
                  const SizedBox(width: 8),
                  AnimatedPet(isCat: false, size: petSize)
                      .animate()
                      .fadeIn(delay: 520.ms, duration: 600.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                        duration: 900.ms,
                      ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 360.ms, duration: 500.ms)
                  .moveY(begin: 20, end: 0, curve: Curves.easeOutCubic),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StartButton(onTap: () => _startTest(context))
            .animate()
            .fadeIn(delay: 700.ms, duration: 450.ms)
            .moveY(begin: 18, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => context.go(AppRoutes.petManualPick),
          child: Text(
            S.petTestSkipBtn,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 820.ms, duration: 400.ms)
            .moveY(begin: 10, end: 0),
      ],
    );
  }
}

/// Spring-y elevated button that subtly "breathes" while idle.
class _StartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.07,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => _press.forward(),
        onTapCancel: () => _press.reverse(),
        onTapUp: (_) {
          _press.reverse();
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _press,
          builder: (context, _) {
            final scale = 1 - _press.value;
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepMoss,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // Pill shape, in line with all other primary CTAs across
                  // the app (register, pet setup, house selection, etc.).
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMoss.withValues(
                        alpha: _hover ? 0.45 : 0.3,
                      ),
                      blurRadius: _hover ? 24 : 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      S.petTestStart,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
