import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/constants/app_strings.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/utils/validators.dart';
import 'package:soulpet/domain/usecases/auth/reset_password_usecase.dart';
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
          child: Padding(
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
                  AppStrings.resetPassword,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _sent
                      ? 'Письмо отправлено! Проверь свой email.'
                      : AppStrings.resetPasswordDesc,
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
                    child: LiquidGlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            decoration: const InputDecoration(
                              hintText: 'example@mail.com',
                              prefixIcon: Icon(
                                  Icons.alternate_email_rounded,
                                  color: AppColors.textHint),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _sendReset,
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(AppStrings.sendResetLink),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  LiquidGlassCard(
                    padding: const EdgeInsets.all(24),
                    dense: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            color: AppColors.success),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.resetEmailSent,
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
