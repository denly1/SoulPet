import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';

class MinigamesScreen extends StatelessWidget {
  const MinigamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мини-игры', style: const TextStyle())),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.extension_outlined,
                  size: 64, color: AppColors.deepMoss.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('Мини-игры',
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
