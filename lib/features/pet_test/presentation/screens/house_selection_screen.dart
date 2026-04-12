import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';

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
  PetType _petType = PetType.cat;
  PetArchetype _archetype = PetArchetype.calm;
  PetGender _gender = PetGender.male;

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
    
    // Очищаем состояние теста
    final prefs = await SharedPreferences.getInstance();
    final storage = PetTestStorage(prefs);
    await storage.clearAll();
    
    // TODO: Создать питомца в БД
    // final pet = PetEntity(
    //   id: uuid.v4(),
    //   userId: currentUserId,
    //   name: _petName,
    //   type: _petType,
    //   archetype: _archetype,
    //   gender: _gender,
    //   houseId: _selectedHouse.name,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // );
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildHouseSelector(),
                const SizedBox(height: 40),
                _buildFinishButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final petEmoji = _petType == PetType.cat ? '🐱' : '🐶';
    
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: AppColors.deepMoss,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Выбери дом для $_petName $petEmoji',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Это место, где будет жить твой питомец',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildHouseSelector() {
    return Column(
      children: [
        _buildHouseCard(
          type: HouseType.apartment,
          emoji: '🏢',
          title: 'Квартира',
          description: 'Уютная городская квартира с видом на город',
        ),
        const SizedBox(height: 16),
        _buildHouseCard(
          type: HouseType.house,
          emoji: '🏡',
          title: 'Дом',
          description: 'Просторный дом с садом и двором',
        ),
      ],
    );
  }

  Widget _buildHouseCard({
    required HouseType type,
    required String emoji,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedHouse == type;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedHouse = type),
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
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? AppColors.deepMoss.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.deepMoss : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.deepMoss : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected 
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _finishSetup,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepMoss,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        disabledBackgroundColor: AppColors.deepMoss.withValues(alpha: 0.5),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Готово! 🎉',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
