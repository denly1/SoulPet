import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class PetResultScreen extends StatefulWidget {
  const PetResultScreen({super.key});

  @override
  State<PetResultScreen> createState() => _PetResultScreenState();
}

class _PetResultScreenState extends State<PetResultScreen>
    with SingleTickerProviderStateMixin {
  TestResult? _result;
  bool _isLoading = true;
  PetType _selectedType = PetType.cat;
  
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _loadResult();
  }

  Future<void> _loadResult() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = PetTestStorage(prefs);
    final result = storage.loadResult();
    
    setState(() {
      _result = result;
      _selectedType = result?.suggestedType ?? PetType.cat;
      _isLoading = false;
    });
    
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectPetType(PetType type) {
    setState(() => _selectedType = type);
  }

  void _continueToSetup() {
    context.go(
      AppRoutes.petSetup,
      extra: {
        'type': _selectedType,
        'archetype': _result?.archetype ?? PetArchetype.calm,
      },
    );
  }

  void _retakeTest() {
    context.go(AppRoutes.petTest);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.warmGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_result == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.warmGradient),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Результат не найден'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _retakeTest,
                  child: const Text('Пройти тест'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildResultCard(),
                const SizedBox(height: 32),
                _buildPetTypeSelector(),
                const SizedBox(height: 32),
                _buildContinueButton(),
                const SizedBox(height: 16),
                _buildRetakeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final archetype = _result!.archetype;
    final emoji = PetTestData.getArchetypeEmoji(archetype);
    final label = PetTestData.getArchetypeLabel(archetype);

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: LiquidGlassCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepMoss.withValues(alpha: 0.8),
                      AppColors.liquidGreen.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Твой архетип',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _result!.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.8),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetTypeSelector() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Text(
            'Выбери питомца',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPetTypeCard(PetType.cat)),
              const SizedBox(width: 16),
              Expanded(child: _buildPetTypeCard(PetType.dog)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetTypeCard(PetType type) {
    final isSelected = _selectedType == type;
    final isCat = type == PetType.cat;
    
    return GestureDetector(
      onTap: () => _selectPetType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.deepMoss.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.deepMoss : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              isCat ? '🐱' : '🐶',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              isCat ? 'Кот' : 'Собака',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (type == _result!.suggestedType) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.deepMoss.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Рекомендуем',
                  style: TextStyle(
                    color: AppColors.deepMoss,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _continueToSetup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepMoss,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Продолжить',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRetakeButton() {
    return TextButton(
      onPressed: _retakeTest,
      child: Text(
        'Пройти тест заново',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
