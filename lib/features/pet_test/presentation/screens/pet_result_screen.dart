import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/pet_illustrations.dart';

/// Displays the outcome of the personality test.
///
/// * Cat wins → "Тебе подходит котик!" + live animated cat illustration
/// * Dog wins → "Тебе подходит собачка!" + live animated dog illustration
/// * Tie     → "Тебе подойдут оба!" with both pets and two CTAs
///
/// A one-shot confetti burst celebrates the result.
class PetResultScreen extends StatefulWidget {
  const PetResultScreen({super.key});

  @override
  State<PetResultScreen> createState() => _PetResultScreenState();
}

class _PetResultScreenState extends State<PetResultScreen> {
  TestResult? _result;
  bool _isLoading = true;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
    _loadResult();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  Future<void> _loadResult() async {
    final prefs = await SharedPreferences.getInstance();
    final result = PetTestStorage(prefs).loadResult();
    setState(() {
      _result = result;
      _isLoading = false;
    });
    // Kick off the confetti after the card has animated in.
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _showConfetti = true);
    // Auto-clear so the widget can be disposed; lightweight cost.
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  void _goToSetup(PetType type) {
    context.go(
      AppRoutes.petSetup,
      extra: <String, dynamic>{
        'type': type,
        'archetype': _result?.archetype ?? PetArchetype.calm,
      },
    );
  }

  Future<void> _retakeTest() async {
    final prefs = await SharedPreferences.getInstance();
    await PetTestStorage(prefs).clearAll();
    if (!mounted) return;
    context.go(AppRoutes.petTestIntro);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.warmGradient),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_result == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.petTestIntro);
      });
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.warmGradient),
          child: SizedBox.shrink(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          sparkleCount: 16,
          pawCount: 4,
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildEyebrow(),
                      const SizedBox(height: 10),
                      _buildHeadline(),
                      const SizedBox(height: 20),
                      _buildPetArtwork(),
                      const SizedBox(height: 28),
                      _buildActions(),
                    ],
                  ),
                ),
              ),
              if (_showConfetti) const Positioned.fill(child: ConfettiBurst()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEyebrow() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.deepMoss.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded,
                size: 14, color: AppColors.deepMoss),
            const SizedBox(width: 6),
            Text(
              S.petResultEyebrow,
              style: TextStyle(
                color: AppColors.deepMoss,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .moveY(begin: -10, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildHeadline() {
    final result = _result!;
    final String title;
    final String subtitle;
    if (result.isTie) {
      title = S.petResultTieTitle;
      subtitle = S.petResultTieSubtitle;
    } else if (result.suggestedType == PetType.cat) {
      title = S.petResultCatTitle;
      subtitle = S.petResultSubtitle;
    } else {
      title = S.petResultDogTitle;
      subtitle = S.petResultSubtitle;
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -0.5,
          ),
        )
            .animate()
            .fadeIn(delay: 120.ms, duration: 500.ms)
            .moveY(begin: 18, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.45,
          ),
        )
            .animate()
            .fadeIn(delay: 220.ms, duration: 500.ms)
            .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }

  Widget _buildPetArtwork() {
    final result = _result!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardMaxWidth = constraints.maxWidth;
        final petSize = result.isTie
            ? (cardMaxWidth * 0.38).clamp(120.0, 170.0)
            : (cardMaxWidth * 0.62).clamp(180.0, 240.0);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.65),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepMoss.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: result.isTie
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedPet(isCat: true, size: petSize)
                        .animate()
                        .fadeIn(delay: 320.ms, duration: 500.ms)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 900.ms,
                        ),
                    const SizedBox(width: 4),
                    AnimatedPet(isCat: false, size: petSize)
                        .animate()
                        .fadeIn(delay: 440.ms, duration: 500.ms)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 900.ms,
                        ),
                  ],
                )
              : Center(
                  child: AnimatedPet(
                    isCat: result.suggestedType == PetType.cat,
                    size: petSize,
                  )
                      .animate()
                      .fadeIn(delay: 320.ms, duration: 500.ms)
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                        duration: 1100.ms,
                      ),
                ),
        )
            .animate()
            .fadeIn(delay: 280.ms, duration: 500.ms)
            .moveY(begin: 24, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }

  Widget _buildActions() {
    final result = _result!;
    if (result.isTie) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PrimaryButton(
            label: S.petResultPickCat,
            icon: Icons.pets_rounded,
            onTap: () => _goToSetup(PetType.cat),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 400.ms)
              .moveY(begin: 16, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 10),
          _PrimaryButton(
            label: S.petResultPickDog,
            icon: Icons.pets_rounded,
            onTap: () => _goToSetup(PetType.dog),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 400.ms)
              .moveY(begin: 16, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 6),
          _retakeButton()
              .animate()
              .fadeIn(delay: 820.ms, duration: 400.ms),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrimaryButton(
          label: S.petResultPickName,
          icon: Icons.edit_rounded,
          onTap: () => _goToSetup(result.suggestedType!),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 400.ms)
            .moveY(begin: 16, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 6),
        _retakeButton()
            .animate()
            .fadeIn(delay: 720.ms, duration: 400.ms),
      ],
    );
  }

  Widget _retakeButton() {
    return TextButton(
      onPressed: _retakeTest,
      child: Text(
        S.petResultRetake,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.05,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deepMoss, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // Pill shape, matching the rest of the primary CTAs.
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMoss.withValues(alpha: 0.36),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
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
    );
  }
}
