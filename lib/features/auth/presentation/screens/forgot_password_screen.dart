import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/utils/validators.dart';
import 'package:soulpet/domain/usecases/auth/reset_password_usecase.dart';
import 'package:soulpet/shared/widgets/auth_field.dart';
import 'package:soulpet/shared/widgets/lang_toggle.dart';
import 'package:soulpet/shared/widgets/sp_snackbar.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await sl<ResetPasswordUseCase>().call(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) => SpSnackbar.show(context, failure.message, isError: true),
      (_) => setState(() => _sent = true),
    );
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary, size: 22),
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(height: 32),
                Icon(Icons.lock_reset_rounded,
                    size: 56, color: AppColors.deepMoss),
                const SizedBox(height: 20),
                Text(
                  S.resetPassword,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (!_sent)
                Text(
                  S.resetPasswordDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                if (!_sent)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthField(
                          controller: _emailController,
                          hint: 'example@mail.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _loading ? null : _sendReset,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                colors: [
                                  _loading
                                      ? AppColors.deepMoss.withValues(alpha: 0.5)
                                      : AppColors.deepMoss,
                                  _loading
                                      ? AppColors.liquidGreen.withValues(alpha: 0.5)
                                      : AppColors.liquidGreen,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: _loading
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppColors.deepMoss.withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      S.sendResetLink,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: LiquidGlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      dense: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.deepMoss, size: 44),
                          const SizedBox(height: 14),
                          Text(
                            S.resetEmailSent,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.deepMoss,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    );
  }
}
