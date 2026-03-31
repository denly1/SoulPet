import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';

class PetSetupScreen extends StatelessWidget {
  const PetSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Настройка питомца', style: const TextStyle())),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_outlined,
                  size: 64, color: AppColors.deepMoss.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('Настройка питомца',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Скоро',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
