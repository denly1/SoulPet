import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/core/utils/validators.dart';
import 'package:soulpet/domain/usecases/auth/login_usecase.dart';
import 'package:soulpet/shared/widgets/sp_snackbar.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/shared/widgets/auth_field.dart';
import 'package:soulpet/shared/widgets/lang_toggle.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await sl<LoginUseCase>().call(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (failure) {
        if (failure.message == S.authEmailNotFound) {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.25),
            builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: LiquidGlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_search_rounded,
                        size: 40, color: AppColors.deepMoss),
                    const SizedBox(height: 14),
                    Text(
                      S.authDialogTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.authDialogBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.mistBorder.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: Text(S.cancel,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              context.go(AppRoutes.register);
                            },
                            child: Container(
                              height: 44,
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
                              ),
                              alignment: Alignment.center,
                              child: Text(S.authDialogRegister,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          SpSnackbar.show(context, failure.message, isError: true);
        }
      },
      // After a successful sign-in let the auth guard pick the next step:
      //   • profile not filled  → /user-profile
      //   • test not finished   → /pet-test-intro
      //   • everything in place → /home
      (tokens) => context.go(AppRoutes.home),
    );
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),

                  // ── Paw glass circle ──
                  LiquidGlassCircle(
                    size: 84,
                    child: Icon(Icons.pets_rounded,
                        size: 42, color: AppColors.deepMoss),
                  ),
                  const SizedBox(height: 22),

                  // ── Glass form card ──
                  LiquidGlassCard(
                    borderRadius: 32,
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          'Soul Pet',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Email field
                        AuthField(
                          controller: _emailController,
                          hint: S.email,
                          validator: Validators.email,
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          disableAutofill: true,
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        AuthField(
                          controller: _passwordController,
                          hint: S.password,
                          validator: Validators.password,
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 10),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () =>
                                context.push(AppRoutes.forgotPassword),
                            child: Text(
                              S.forgotPassword,
                              style: TextStyle(
                                color: AppColors.deepMoss,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign In button
                        _PrimaryButton(
                          label: S.login,
                          loading: _loading,
                          onTap: _login,
                        ),
                        const SizedBox(height: 16),

                        // Don't have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.noAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.register),
                              child: Text(
                                S.register,
                                style: TextStyle(
                                  color: AppColors.deepMoss,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── OR ──
                  _OrDivider(),
                  const SizedBox(height: 18),

                  // ── Sign in with label ──
                  Text(
                    S.orContinueWith,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Social pill buttons ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        label: 'Google',
                        isGoogle: true,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      _SocialButton(
                        label: 'Apple',
                        isGoogle: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                ],
              ),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared auth widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onTap;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
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
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
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

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.mistBorder, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            S.or,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.mistBorder, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final bool isGoogle;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.isGoogle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        borderRadius: 50,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGoogle)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEA4335),
                      height: 1.0,
                    ),
                  ),
                ),
              )
            else
              const Icon(Icons.apple_rounded,
                  size: 22, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
