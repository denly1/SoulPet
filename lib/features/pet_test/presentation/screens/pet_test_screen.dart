import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class PetTestScreen extends StatefulWidget {
  const PetTestScreen({super.key});

  @override
  State<PetTestScreen> createState() => _PetTestScreenState();
}

class _PetTestScreenState extends State<PetTestScreen> 
    with SingleTickerProviderStateMixin {
  late PetTestStorage _storage;
  PetTestState _state = const PetTestState();
  bool _isLoading = true;
  bool _isAnimating = false;
  
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _initStorage();
  }

  Future<void> _initStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _storage = PetTestStorage(prefs);
    
    final savedState = _storage.loadState();
    if (savedState != null && !savedState.isCompleted) {
      _state = savedState;
    }
    
    setState(() => _isLoading = false);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<TestQuestion> get _questions => PetTestData.questions;
  TestQuestion get _currentQuestion => _questions[_state.currentQuestionIndex];
  double get _progress => (_state.currentQuestionIndex + 1) / _questions.length;
  bool get _isLastQuestion => _state.currentQuestionIndex >= _questions.length - 1;

  Future<void> _selectAnswer(int answerId) async {
    if (_isAnimating) return;
    
    setState(() => _isAnimating = true);
    
    final newAnswers = Map<int, int>.from(_state.answers);
    newAnswers[_currentQuestion.id] = answerId;
    
    _state = _state.copyWith(answers: newAnswers);
    await _storage.saveState(_state);
    
    await _animController.reverse();
    
    if (_isLastQuestion) {
      _state = _state.copyWith(isCompleted: true);
      await _storage.saveState(_state);
      
      final result = PetTestData.calculateResult(_state.answers);
      await _storage.saveResult(result);
      
      if (mounted) {
        context.go(AppRoutes.petResult);
      }
    } else {
      setState(() {
        _state = _state.copyWith(
          currentQuestionIndex: _state.currentQuestionIndex + 1,
        );
        _isAnimating = false;
      });
      _animController.forward();
    }
  }

  Future<void> _goBack() async {
    if (_state.currentQuestionIndex > 0) {
      await _animController.reverse();
      setState(() {
        _state = _state.copyWith(
          currentQuestionIndex: _state.currentQuestionIndex - 1,
        );
      });
      _animController.forward();
    } else {
      context.pop();
    }
  }

  Future<void> _restartTest() async {
    await _storage.clearAll();
    setState(() {
      _state = const PetTestState();
    });
    _animController.forward(from: 0);
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: _buildQuestionCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.deepMoss,
          ),
          Expanded(
            child: Text(
              'Вопрос ${_state.currentQuestionIndex + 1} из ${_questions.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: _restartTest,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.deepMoss.withValues(alpha: 0.6),
            tooltip: 'Начать заново',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepMoss),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_progress * 100).toInt()}% завершено',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 48,
                  color: AppColors.deepMoss.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentQuestion.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ..._currentQuestion.answers.map((answer) => _buildAnswerButton(answer)),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(TestAnswer answer) {
    final isSelected = _state.answers[_currentQuestion.id] == answer.id;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _selectAnswer(answer.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.deepMoss.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? AppColors.deepMoss 
                  : Colors.white.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? AppColors.deepMoss 
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.deepMoss 
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: isSelected 
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  answer.text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
