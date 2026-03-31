import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/constants/app_strings.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/core/utils/validators.dart';
import 'package:soulpet/domain/usecases/auth/register_usecase.dart';
import 'package:soulpet/shared/widgets/sp_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await sl<RegisterUseCase>().call(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) => SpSnackbar.show(context, failure.message, isError: true),
      (tokens) => context.go(AppRoutes.home),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 22),
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.spa_outlined,
                      size: 48, color: AppColors.deepMoss),
                  const SizedBox(height: 12),
                  Text(
                    'Создать аккаунт',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Твой питомец уже ждёт',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Glass form card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: AppColors.glassBlurSigma,
                        sigmaY: AppColors.glassBlurSigma,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: AppColors.glassGradient,
                          border: Border.all(color: AppColors.glassBorder, width: 0.8),
                          boxShadow: AppColors.glassShadow,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              validator: Validators.username,
                              decoration: const InputDecoration(
                                hintText: 'Имя пользователя',
                                prefixIcon: Icon(Icons.person_outline_rounded,
                                    color: AppColors.textHint),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: Validators.password,
                              decoration: InputDecoration(
                                hintText: 'Пароль (мин. 8 символов)',
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColors.textHint),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textHint,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              validator: (v) => Validators.confirmPassword(
                                  v, _passwordController.text),
                              decoration: InputDecoration(
                                hintText: 'Повторите пароль',
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColors.textHint),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textHint,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureConfirm = !_obscureConfirm),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _register,
                                child: _loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(AppStrings.register),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.haveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          AppStrings.login,
                          style: TextStyle(
                            color: AppColors.deepMoss,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
