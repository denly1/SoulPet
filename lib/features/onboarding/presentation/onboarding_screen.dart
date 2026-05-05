import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/shared/widgets/lang_toggle.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _icons = [
    Icons.spa_outlined,
    Icons.wb_twilight_rounded,
    Icons.auto_awesome_outlined,
  ];

  // Locale-aware copy. Backed by S.* so the EN/RU toggle re-localises live.
  List<String> get _titles => [
        S.onboardingTitle1,
        S.onboardingTitle2,
        S.onboardingTitle3,
      ];
  List<String> get _descs => [
        S.onboardingDesc1,
        S.onboardingDesc2,
        S.onboardingDesc3,
      ];

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _finish() async {
    await sl<AuthLocalDatasource>().markOnboardingDone();
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar: language toggle on the left, skip on the right.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    const LangToggle(),
                    const Spacer(),
                    SizedBox(
                      height: 40,
                      child: _currentPage < 2
                          ? TextButton(
                              onPressed: _finish,
                              child: Text(
                                S.skip,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Glass circle with icon
                          LiquidGlassCircle(
                            size: 150,
                            child: Icon(
                              _icons[index],
                              size: 68,
                              color: AppColors.deepMoss,
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            _titles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _descs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Bottom: dots + button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentPage
                                ? AppColors.deepMoss
                                : AppColors.mistBorder,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _PillButton(
                      label: _currentPage == 2 ? S.getStarted : S.next,
                      onTap: _next,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped gradient button — visually identical to the primary CTAs on
/// the auth and profile screens so the onboarding doesn't feel out of place.
class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
