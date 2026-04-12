import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class PetSetupScreen extends StatefulWidget {
  const PetSetupScreen({super.key});

  @override
  State<PetSetupScreen> createState() => _PetSetupScreenState();
}

class _PetSetupScreenState extends State<PetSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  PetType _petType = PetType.cat;
  PetArchetype _archetype = PetArchetype.calm;
  PetGender _gender = PetGender.male;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _petType = extra['type'] as PetType? ?? PetType.cat;
      _archetype = extra['archetype'] as PetArchetype? ?? PetArchetype.calm;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _petEmoji => _petType == PetType.cat ? '🐱' : '🐶';
  String get _petTypeLabel => _petType == PetType.cat ? 'котика' : 'собачку';

  Future<void> _createPet() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Здесь будет создание питомца в БД
    // Пока просто переходим к выбору дома
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      context.go(
        AppRoutes.houseSelection,
        extra: {
          'name': _nameController.text.trim(),
          'type': _petType,
          'archetype': _archetype,
          'gender': _gender,
        },
      );
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildPetPreview(),
                  const SizedBox(height: 32),
                  _buildNameInput(),
                  const SizedBox(height: 24),
                  _buildGenderSelector(),
                  const SizedBox(height: 40),
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          'Познакомься с $_petTypeLabel!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Дай имя своему новому другу',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildPetPreview() {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.deepMoss.withValues(alpha: 0.2),
                  AppColors.liquidGreen.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                _petEmoji,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_nameController.text.isNotEmpty)
            Text(
              _nameController.text,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Имя питомца',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Введи имя...',
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.deepMoss, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Пожалуйста, введи имя питомца';
            }
            if (value.trim().length < 2) {
              return 'Имя должно быть не менее 2 символов';
            }
            if (value.trim().length > 20) {
              return 'Имя должно быть не более 20 символов';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пол питомца',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGenderCard(PetGender.male)),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard(PetGender.female)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(PetGender gender) {
    final isSelected = _gender == gender;
    final isMale = gender == PetGender.male;
    
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.deepMoss.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.deepMoss : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isMale ? Icons.male_rounded : Icons.female_rounded,
              size: 32,
              color: isSelected 
                  ? AppColors.deepMoss 
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              isMale ? 'Мальчик' : 'Девочка',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _createPet,
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
              'Продолжить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
