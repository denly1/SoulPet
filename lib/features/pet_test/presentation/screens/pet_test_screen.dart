import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/pet_test_storage.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// 6-question personality test with an animated progress bar and smooth
/// slide transitions between questions. Selection is confirmed via
/// "Далее" — no auto-advance (ТЗ: запрет пропусков + возможность назад).
class PetTestScreen extends StatefulWidget {
  const PetTestScreen({super.key});

  @override
  State<PetTestScreen> createState() => _PetTestScreenState();
}

class _PetTestScreenState extends State<PetTestScreen>
    with TickerProviderStateMixin {
  PetTestStorage? _storage;
  PetTestState _state = const PetTestState();
  bool _isLoading = true;
  bool _navigating = false;
  int _direction = 1; // 1 = forward, -1 = backward (for slide animations)

  late final AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
    LocaleProvider.instance.addListener(_onLocaleChanged);
    _initStorage();
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _initStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = PetTestStorage(prefs);
    final saved = storage.loadState();
    setState(() {
      _storage = storage;
      if (saved != null && !saved.isCompleted) {
        final clamped = saved.currentQuestionIndex.clamp(
          0,
          PetTestData.questions.length - 1,
        );
        _state = saved.copyWith(currentQuestionIndex: clamped);
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _slideController.dispose();
    super.dispose();
  }

  List<TestQuestion> get _questions => PetTestData.questions;
  TestQuestion get _currentQuestion => _questions[_state.currentQuestionIndex];
  int get _totalQuestions => _questions.length;
  int get _currentNumber => _state.currentQuestionIndex + 1;
  double get _progress => _currentNumber / _totalQuestions;
  bool get _isLastQuestion =>
      _state.currentQuestionIndex >= _totalQuestions - 1;
  bool get _isFirstQuestion => _state.currentQuestionIndex == 0;
  TestOption? get _selectedOption => _state.optionFor(_currentQuestion.id);
  bool get _canProceed => _selectedOption != null;

  Future<void> _selectOption(TestOption option) async {
    if (_navigating) return;
    final answers = Map<int, int>.from(_state.answers)
      ..[_currentQuestion.id] = option.index;
    setState(() {
      _state = _state.copyWith(answers: answers);
    });
    await _storage?.saveState(_state);
  }

  Future<void> _goNext() async {
    if (!_canProceed || _navigating) return;
    _navigating = true;

    if (_isLastQuestion) {
      final completed = _state.copyWith(isCompleted: true);
      setState(() => _state = completed);
      await _storage?.saveState(completed);
      final result = PetTestData.calculateResult(completed.answers);
      await _storage?.saveResult(result);
      if (!mounted) return;
      context.go(AppRoutes.petResult);
      return;
    }

    setState(() => _direction = 1);
    await _slideController.reverse();
    setState(() {
      _state = _state.copyWith(
        currentQuestionIndex: _state.currentQuestionIndex + 1,
      );
      _navigating = false;
    });
    await _storage?.saveState(_state);
    await _slideController.forward();
  }

  Future<void> _goBack() async {
    if (_navigating) return;
    if (_isFirstQuestion) {
      context.go(AppRoutes.petTestIntro);
      return;
    }
    _navigating = true;
    setState(() => _direction = -1);
    await _slideController.reverse();
    setState(() {
      _state = _state.copyWith(
        currentQuestionIndex: _state.currentQuestionIndex - 1,
      );
      _navigating = false;
    });
    await _storage?.saveState(_state);
    await _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.warmGradient),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          sparkleCount: 8,
          pawCount: 3,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildProgressBar(),
                Expanded(child: _buildQuestionPager()),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: LiquidGlassCircle(
              size: 40,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.deepMoss,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.deepMoss.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$_currentNumber / $_totalQuestions',
              style: TextStyle(
                color: AppColors.deepMoss,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: _progress),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.mistBorder.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.liquidGreen,
                      AppColors.deepMoss,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMoss.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPager() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, _) {
        final t = _slideController.value;
        final offset = (1 - t) * _direction * 40;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: _buildQuestionBody(),
          ),
        );
      },
    );
  }

  Widget _buildQuestionBody() {
    final q = _currentQuestion;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        key: ValueKey(q.id),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            q.text,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.2,
            ),
          ).animate(key: ValueKey('q-${q.id}')).fadeIn(duration: 300.ms).moveY(
                begin: 8,
                end: 0,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 26),
          _AnswerCard(
            answer: q.answerA,
            selected: _selectedOption == TestOption.a,
            onTap: () => _selectOption(TestOption.a),
          )
              .animate(key: ValueKey('a-${q.id}'))
              .fadeIn(delay: 60.ms, duration: 350.ms)
              .moveY(begin: 16, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 14),
          _AnswerCard(
            answer: q.answerB,
            selected: _selectedOption == TestOption.b,
            onTap: () => _selectOption(TestOption.b),
          )
              .animate(key: ValueKey('b-${q.id}'))
              .fadeIn(delay: 160.ms, duration: 350.ms)
              .moveY(begin: 16, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _navigating ? null : _goBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(
                    color: AppColors.mistBorder,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  S.petTestBack,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _NextButton(
                enabled: _canProceed && !_navigating,
                isLast: _isLastQuestion,
                onTap: _goNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerCard extends StatefulWidget {
  final TestAnswer answer;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerCard({
    required this.answer,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<_AnswerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapCancel: () => _press.reverse(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, _) {
          final scale = 1 - _press.value;
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: widget.selected
                    ? AppColors.deepMoss.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: widget.selected
                      ? AppColors.deepMoss
                      : Colors.white.withValues(alpha: 0.6),
                  width: widget.selected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.selected
                        ? AppColors.deepMoss.withValues(alpha: 0.22)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: widget.selected ? 22 : 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.answer.text,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: widget.selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.selected
                          ? AppColors.deepMoss
                          : AppColors.softJade.withValues(alpha: 0.35),
                      boxShadow: widget.selected
                          ? [
                              BoxShadow(
                                color: AppColors.deepMoss.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.answer.icon,
                      size: 22,
                      color: widget.selected
                          ? Colors.white
                          : AppColors.deepMoss,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final bool enabled;
  final bool isLast;
  final VoidCallback onTap;

  const _NextButton({
    required this.enabled,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0,
      upperBound: 0.06,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    return GestureDetector(
      onTapDown: disabled ? null : (_) => _press.forward(),
      onTapCancel: disabled ? null : () => _press.reverse(),
      onTapUp: disabled
          ? null
          : (_) {
              _press.reverse();
              widget.onTap();
            },
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, _) {
          final scale = 1 - _press.value;
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: disabled
                      ? [
                          AppColors.deepMoss.withValues(alpha: 0.35),
                          AppColors.deepMoss.withValues(alpha: 0.35),
                        ]
                      : [AppColors.deepMoss, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: disabled
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.deepMoss.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isLast ? S.petTestFinish : S.petTestNext,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.isLast
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
