import 'dart:ui';
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final petSize =
                          (constraints.maxWidth * 0.38).clamp(120.0, 170.0);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _PetPickCard(
                              isCat: true,
                              size: petSize,
                              label: S.petManualKitten,
                              desc: S.petManualKittenDesc,
                              onTap: () => _pick(context, PetType.cat),
                            )
                                .animate()
                                .fadeIn(delay: 220.ms, duration: 450.ms)
                                .moveY(
                                    begin: 24,
                                    end: 0,
                                    curve: Curves.easeOutCubic),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PetPickCard(
                              isCat: false,
                              size: petSize,
                              label: S.petManualPuppy,
                              desc: S.petManualPuppyDesc,
                              onTap: () => _pick(context, PetType.dog),
                            )
                                .animate()
                                .fadeIn(delay: 340.ms, duration: 450.ms)
                                .moveY(
                                    begin: 24,
                                    end: 0,
                                    curve: Curves.easeOutCubic),
                          ),
                        ],
                      );
                    },
                  ),
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

class _PetPickCard extends StatefulWidget {
  final bool isCat;
  final double size;
  final String label;
  final String desc;
  final VoidCallback onTap;

  const _PetPickCard({
    required this.isCat,
    required this.size,
    required this.label,
    required this.desc,
    required this.onTap,
  });

  @override
  State<_PetPickCard> createState() => _PetPickCardState();
}

class _PetPickCardState extends State<_PetPickCard>
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
    final accent = widget.isCat
        ? const Color(0xFF8EC5A8)
        : const Color(0xFFE8B97A);

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
          return Transform.scale(
            scale: 1 - _press.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.82),
                            accent.withValues(alpha: 0.20),
                            Colors.white.withValues(alpha: 0.65),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 1.5,
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(color: Colors.transparent),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: widget.size * 0.85,
                                height: widget.size * 0.85,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      accent.withValues(alpha: 0.30),
                                      accent.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedPet(isCat: widget.isCat, size: widget.size),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  accent.withValues(alpha: 0.55),
                                  accent.withValues(alpha: 0.30),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.desc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
