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
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/pet_illustrations.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';
import 'package:soulpet/shared/widgets/pill_text_field.dart';

class PetSetupScreen extends StatefulWidget {
  const PetSetupScreen({super.key});

  @override
  State<PetSetupScreen> createState() => _PetSetupScreenState();
}

class _PetSetupScreenState extends State<PetSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  PetType _petType = PetType.cat;
  PetArchetype _archetype = PetArchetype.calm;
  PetGender _gender = PetGender.male;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _petType = extra['type'] as PetType? ?? PetType.cat;
      _archetype = extra['archetype'] as PetArchetype? ?? PetArchetype.calm;
    }
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // NOTE: Pet is NOT yet persisted to the backend at this point — per ТЗ the
    // result is finalized only after the user confirms on the next (house)
    // screen. We therefore just pass values forward.
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      context.go(
        AppRoutes.houseSelection,
        extra: {
          'name': _nameController.text.trim(),
          'type': _petType,
          'archetype': _archetype,
          'gender': _gender,
        },
      );
    }
  }

  Future<void> _retakeTest() async {
    // Previous result is not locked in, so wipe any cached state and go back
    // to the test intro.
    final prefs = await SharedPreferences.getInstance();
    await PetTestStorage(prefs).clearAll();
    if (!mounted) return;
    context.go(AppRoutes.petTestIntro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          sparkleCount: 10,
          pawCount: 3,
          child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  _buildStepIndicator(),
                  const SizedBox(height: 22),
                  _buildPetPreview(),
                  const SizedBox(height: 30),
                  _buildNameInput(),
                  const SizedBox(height: 26),
                  _buildGenderSelector(),
                  const SizedBox(height: 36),
                  _buildCreateButton(),
                  const SizedBox(height: 4),
                  _buildRetakeButton(),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          S.petSetupTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            height: 1.15,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .moveY(begin: 8, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        Text(
          S.petSetupSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        )
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.deepMoss.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.deepMoss.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets_rounded, size: 14, color: AppColors.deepMoss),
            const SizedBox(width: 6),
            Text(
              S.petSetupStepLabel,
              style: TextStyle(
                color: AppColors.deepMoss,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 180.ms, duration: 400.ms);
  }

  Widget _buildPetPreview() {
    final hasName = _nameController.text.trim().isNotEmpty;
    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      borderRadius: 32,
      child: Column(
        children: [
          // Pulsing aura behind the pet sprite for a soft "alive" vibe.
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (_petType == PetType.cat
                                ? const Color(0xFF8EC5A8)
                                : const Color(0xFFE8B97A))
                            .withValues(alpha: 0.45),
                        (_petType == PetType.cat
                                ? const Color(0xFF8EC5A8)
                                : const Color(0xFFE8B97A))
                            .withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.94, 0.94),
                      end: const Offset(1.06, 1.06),
                      curve: Curves.easeInOut,
                      duration: 2000.ms,
                    ),
                AnimatedPet(
                  isCat: _petType == PetType.cat,
                  size: 172,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.82, 0.82),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                      duration: 900.ms,
                    ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Animated name pill — appears as soon as the user starts typing.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                sizeFactor: anim,
                axisAlignment: -1,
                child: child,
              ),
            ),
            child: hasName
                ? Container(
                    key: ValueKey(_nameController.text.trim()),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepMoss.withValues(alpha: 0.85),
                          AppColors.liquidGreen.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepMoss.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_rounded,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          _nameController.text.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 0, width: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 8),
          child: Text(
            S.petSetupNameLabel,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        PillTextField(
          controller: _nameController,
          hint: S.petSetupNameHint,
          icon: Icons.pets_rounded,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return S.petNameRequired;
            }
            if (value.trim().length < 2) {
              return S.petNameTooShort;
            }
            if (value.trim().length > 20) {
              return S.petNameTooLong;
            }
            return null;
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            S.petSetupNameExample,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            S.petSetupGenderLabel,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildGenderCard(PetGender.male)),
            const SizedBox(width: 12),
            Expanded(child: _buildGenderCard(PetGender.female)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(PetGender gender) {
    final isSelected = _gender == gender;
    final isMale = gender == PetGender.male;
    // Match the user-profile palette so both gender pickers feel consistent.
    final accent = isMale ? const Color(0xFF5C8FB8) : const Color(0xFFD98695);

    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.85),
                    accent.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? accent : Colors.white.withValues(alpha: 0.6),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accent.withValues(alpha: 0.32)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 22 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : accent.withValues(alpha: 0.14),
              ),
              alignment: Alignment.center,
              child: Icon(
                isMale ? Icons.male_rounded : Icons.female_rounded,
                size: 26,
                color: isSelected ? Colors.white : accent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isMale ? S.petSetupBoy : S.petSetupGirl,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    // Design consistent with the Register screen's primary button — pill-shaped
    // glassy button with a deepMoss→liquidGreen gradient and white border.
    return GestureDetector(
      onTap: _isLoading ? null : _createPet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepMoss.withValues(alpha: 0.85),
              AppColors.liquidGreen.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepMoss.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.petSetupContinue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildRetakeButton() {
    return TextButton(
      onPressed: _isLoading ? null : _retakeTest,
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
