import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/house_illustrations.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

enum HouseType { apartment, house }

class HouseSelectionScreen extends StatefulWidget {
  const HouseSelectionScreen({super.key});

  @override
  State<HouseSelectionScreen> createState() => _HouseSelectionScreenState();
}

class _HouseSelectionScreenState extends State<HouseSelectionScreen> {
  HouseType _selectedHouse = HouseType.apartment;
  bool _isLoading = false;

  String _petName = '';
  // _gender drives the gender agreement on 'твой' / 'твоя' in the subtitle.
  PetGender _gender = PetGender.male;
  // NOTE: _petType and _archetype are currently not persisted because
  // the pet is not yet created on the backend; kept for future
  // `PetEntity` construction.
  // ignore: unused_field
  PetType _petType = PetType.cat;
  // ignore: unused_field
  PetArchetype _archetype = PetArchetype.calm;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _petName = extra['name'] as String? ?? '';
      _petType = extra['type'] as PetType? ?? PetType.cat;
      _archetype = extra['archetype'] as PetArchetype? ?? PetArchetype.calm;
      _gender = extra['gender'] as PetGender? ?? PetGender.male;
    }
  }

  Future<void> _finishSetup() async {
    setState(() => _isLoading = true);

    // Clear the test state — it has served its purpose.
    final prefs = await SharedPreferences.getInstance();
    await PetTestStorage(prefs).clearAll();

    // Mark the personality test as completed so the auth guard lets the user
    // into the main app flow from now on.
    await sl<AuthLocalDatasource>().markPetTestDone();

    // TODO: Persist the created pet to the backend.

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      context.go(AppRoutes.home);
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildHouseSelector(),
                  const SizedBox(height: 36),
                  _buildFinishButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Title stays in nominative — we deliberately don't try to inject the
    // pet's name here because Russian would need the name in genitive case
    // ('для Мурки', not 'для Мурка') and there's no reliable way to decline
    // arbitrary nicknames programmatically.
    final title = S.houseTitle;

    // Subtitle uses the user-chosen pet nickname directly. RU needs gender
    // agreement on 'твой' / 'твоя', so we pick the prefix that matches the
    // pet's gender chosen on the previous screen.
    final prefix = _gender == PetGender.female
        ? S.houseSubtitlePrefixFemale
        : S.houseSubtitlePrefixMale;
    final subtitle = _petName.isEmpty
        ? S.houseSubtitleFallback
        : '$prefix$_petName${S.houseSubtitleSuffix}';

    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go(AppRoutes.home),
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
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.3,
          ),
        )
            .animate()
            .fadeIn(duration: 450.ms)
            .moveY(begin: 10, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        )
            .animate()
            .fadeIn(delay: 80.ms, duration: 400.ms)
            .moveY(begin: 6, end: 0),
      ],
    );
  }

  Widget _buildHouseSelector() {
    return Column(
      children: [
        _buildHouseCard(
          type: HouseType.apartment,
          illustration: const ApartmentIllustration(
            width: double.infinity,
            height: 150,
          ),
          title: S.houseApartmentTitle,
          description: S.houseApartmentDesc,
          delayMs: 120,
        ),
        const SizedBox(height: 16),
        _buildHouseCard(
          type: HouseType.house,
          illustration: const HouseIllustration(
            width: double.infinity,
            height: 150,
          ),
          title: S.houseHouseTitle,
          description: S.houseHouseDesc,
          delayMs: 220,
        ),
      ],
    );
  }

  Widget _buildHouseCard({
    required HouseType type,
    required Widget illustration,
    required String title,
    required String description,
    required int delayMs,
  }) {
    final isSelected = _selectedHouse == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedHouse = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.deepMoss.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isSelected
                ? AppColors.deepMoss
                : Colors.white.withValues(alpha: 0.6),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.deepMoss.withValues(alpha: 0.22)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 22 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full-width illustration with a soft radio selection indicator
              // floating in the top-right corner.
              //
              // The Stack must be wrapped in a SizedBox with a concrete height
              // — without it, a Stack that has only Positioned children
              // collapses to 0×0 (no non-positioned child to size against),
              // and `Positioned.fill` paints nothing. That's why the apartment
              // / house art was invisible.
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    Positioned.fill(child: illustration),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.deepMoss
                            : Colors.white.withValues(alpha: 0.9),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.deepMoss
                              : Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded,
                              size: 18, color: Colors.white)
                          : null,
                    ),
                  ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 400.ms)
        .moveY(begin: 14, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildFinishButton() {
    // Identical to the Register screen's primary button — pill 54px, glassy
    // green gradient, white border, soft shadow.
    return GestureDetector(
      onTap: _isLoading ? null : _finishSetup,
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
              : Text(
                  S.houseDone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 420.ms, duration: 450.ms)
        .moveY(begin: 14, end: 0, curve: Curves.easeOutCubic);
  }
}
