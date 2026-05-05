import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/pet_illustrations.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// Manual cat/dog selection screen — reached by skipping the personality test.
class PetManualPickScreen extends StatefulWidget {
  const PetManualPickScreen({super.key});

  @override
  State<PetManualPickScreen> createState() => _PetManualPickScreenState();
}

class _PetManualPickScreenState extends State<PetManualPickScreen> {
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

  void _pick(BuildContext context, PetType type) {
    context.go(
      AppRoutes.petSetup,
      extra: <String, dynamic>{
        'type': type,
        'archetype':
            type == PetType.dog ? PetArchetype.active : PetArchetype.calm,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          sparkleCount: 10,
          pawCount: 4,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go(AppRoutes.petTestIntro),
                        child: LiquidGlassCircle(
                          size: 42,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.deepMoss,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      S.petManualTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -0.3,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      S.petManualSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .moveY(begin: 8, end: 0),
                  const SizedBox(height: 28),
                  _PetOptionCard(
                    isCat: true,
                    title: S.petManualKitten,
                    description: S.petManualKittenDesc,
                    onTap: () => _pick(context, PetType.cat),
                  )
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 450.ms)
                      .moveX(begin: -12, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 14),
                  _PetOptionCard(
                    isCat: false,
                    title: S.petManualPuppy,
                    description: S.petManualPuppyDesc,
                    onTap: () => _pick(context, PetType.dog),
                  )
                      .animate()
                      .fadeIn(delay: 340.ms, duration: 450.ms)
                      .moveX(begin: 12, end: 0, curve: Curves.easeOutCubic),
                  const Spacer(),
                  Center(
                    child: Text(
                      S.petManualHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PetOptionCard extends StatefulWidget {
  final bool isCat;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _PetOptionCard({
    required this.isCat,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<_PetOptionCard> createState() => _PetOptionCardState();
}

class _PetOptionCardState extends State<_PetOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0,
      upperBound: 0.04,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.65),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMoss.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: AnimatedPet(isCat: widget.isCat, size: 92),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.deepMoss.withValues(alpha: 0.12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.deepMoss,
                      size: 22,
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
