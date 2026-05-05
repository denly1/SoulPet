import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/constants/app_constants.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/profile/user_profile_provider.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/domain/entities/user_profile_entity.dart';
import 'package:soulpet/features/pet_test/presentation/widgets/decorative_background.dart';
import 'package:soulpet/shared/widgets/lang_toggle.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';
import 'package:soulpet/shared/widgets/pill_text_field.dart';
import 'package:soulpet/shared/widgets/sp_snackbar.dart';

/// One-time onboarding screen shown right after the user creates an account
/// (or signs in for the first time on a fresh install). Collects:
///   * nickname  — how to address the user across the app
///   * gender    — drives gendered verb endings ("ты выбрал" vs "ты выбрала")
///   * age       — kept locally for future personalization
///
/// On submit the profile is persisted via [UserProfileProvider] and the user
/// is sent to the personality test. The auth guard in [AppRouter] won't let
/// them past this screen until it's filled in.
class UserProfileSetupScreen extends StatefulWidget {
  const UserProfileSetupScreen({super.key});

  @override
  State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  // Nullable so the user is forced to make an explicit choice. The previous
  // 'Не указывать' option was removed by request — we ask for either male
  // or female now.
  UserGender? _gender;
  // Birth date replaces the old free-form age input. We still derive an
  // integer age from it before saving so [UserProfile] can stay unchanged.
  DateTime? _birthDate;
  bool _saving = false;

  // Tracks whether the form has been submitted at least once — used to delay
  // showing the inline 'date is required' helper until the user actually tries
  // to continue, so the screen doesn't look error-y on first paint.
  bool _showBirthDateError = false;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
    // If somehow the screen is reached with an existing profile (e.g. user
    // navigated back manually), pre-fill the form so they don't lose data.
    final existing = UserProfileProvider.instance.profile;
    if (existing != null) {
      _nicknameController.text = existing.nickname;
      if (existing.age > 0) {
        // We don't persist the exact birth date — approximate it as Jan 1st
        // of `currentYear - age`. The user can re-pick to refine it.
        final now = DateTime.now();
        _birthDate = DateTime(now.year - existing.age, 1, 1);
      }
      _gender = existing.gender == UserGender.unspecified
          ? null
          : existing.gender;
    }
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _nicknameController.dispose();
    super.dispose();
  }

  String? _validateNickname(String? raw) {
    final v = raw?.trim() ?? '';
    if (v.isEmpty) return S.fieldRequired;
    if (v.length < AppConstants.minNicknameLength) return S.nicknameTooShort;
    if (v.length > AppConstants.maxNicknameLength) return S.nicknameTooLong;
    return null;
  }

  // Computes the user's age in completed years from the picked birth date,
  // taking into account whether the birthday has already happened this year.
  int _ageFromBirthDate(DateTime dob) {
    final now = DateTime.now();
    var years = now.year - dob.year;
    final hadBirthdayThisYear = (now.month > dob.month) ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hadBirthdayThisYear) years -= 1;
    return years;
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    final dobMissing = _birthDate == null;
    if (dobMissing) {
      setState(() => _showBirthDateError = true);
    }
    if (!formOk || dobMissing) return;
    if (_gender == null) {
      SpSnackbar.show(context, S.userProfileGenderRequired, isError: true);
      return;
    }
    final age = _ageFromBirthDate(_birthDate!);
    if (age < AppConstants.minUserAge || age > AppConstants.maxUserAge) {
      SpSnackbar.show(context, S.ageInvalid, isError: true);
      return;
    }
    setState(() => _saving = true);

    final profile = UserProfile(
      gender: _gender!,
      age: age,
      nickname: _nicknameController.text.trim(),
    );
    await UserProfileProvider.instance.save(profile);

    if (!mounted) return;
    // Fresh user: send them to the personality test next.
    context.go(AppRoutes.petTestIntro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: DecorativeBackground(
          sparkleCount: 10,
          pawCount: 3,
          child: SafeArea(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStepIndicator(),
                        const SizedBox(height: 22),
                        _buildHeader(),
                        const SizedBox(height: 28),
                        _buildFormCard(),
                        const SizedBox(height: 22),
                        _buildSubmitButton(),
                        const SizedBox(height: 8),
                      ],
                    ),
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
      ),
    );
  }

  // Wraps nickname / age / gender in a single soft glass card so the form
  // reads as one cohesive block instead of three floating items.
  Widget _buildFormCard() {
    return LiquidGlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNicknameField(),
          const SizedBox(height: 18),
          _buildAgeField(),
          const SizedBox(height: 20),
          _buildGenderSelector(),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 220.ms, duration: 450.ms)
        .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildStepIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.deepMoss.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.deepMoss.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_rounded, size: 14, color: AppColors.deepMoss),
            const SizedBox(width: 6),
            Text(
              S.userProfileStepLabel,
              style: TextStyle(
                color: AppColors.deepMoss,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .moveY(begin: -8, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildHeader() {
    final greeting = _nicknameController.text.trim();
    // Subtitle is intentionally absent now — the title alone reads cleaner.
    return Column(
      children: [
        // Big circular liquid-glass avatar with a waving-hand icon — sets
        // the tone of the screen without crowding the form.
        LiquidGlassCircle(
          size: 78,
          child: Icon(
            Icons.waving_hand_rounded,
            size: 36,
            color: AppColors.deepMoss,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        const SizedBox(height: 16),
        Text(
          greeting.isEmpty
              ? S.userProfileTitle
              : '${S.userProfileGreetingPrefix} $greeting!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            height: 1.2,
          ),
        )
            .animate(key: ValueKey(greeting))
            .fadeIn(duration: 350.ms)
            .moveY(begin: 6, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }

  Widget _buildNicknameField() {
    return _LabeledField(
      label: S.userProfileNicknameLabel,
      delayMs: 280,
      child: PillTextField(
        controller: _nicknameController,
        hint: S.userProfileNicknameHint,
        icon: Icons.person_outline_rounded,
        validator: _validateNickname,
        textCapitalization: TextCapitalization.words,
        // Live-update the greeting in the header as the user types.
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildAgeField() {
    return _LabeledField(
      label: S.userProfileAgeLabel,
      delayMs: 360,
      child: _BirthDatePillField(
        value: _birthDate,
        showError: _showBirthDateError && _birthDate == null,
        hint: S.userProfileAgeHint,
        onTap: _openBirthDatePicker,
      ),
    );
  }

  Future<void> _openBirthDatePicker() async {
    // Reasonable defaults: max DOB is today, min is 100 years ago, initial
    // pick lands somewhere believable so the user isn't stuck spinning the
    // year wheel from 2000.
    final now = DateTime.now();
    final minDate = DateTime(now.year - AppConstants.maxUserAge - 1);
    final maxDate = DateTime(now.year - AppConstants.minUserAge,
        now.month, now.day);
    final initial = _birthDate ??
        DateTime(now.year - 18, now.month, now.day);

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _BirthDatePickerSheet(
        initialDate: initial,
        minDate: minDate,
        maxDate: maxDate,
      ),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _showBirthDateError = false;
      });
    }
  }

  Widget _buildGenderSelector() {
    // With only two options the cards can breathe — bigger icons, taller
    // tiles, more readable copy. Distinct accents keep the selected state
    // obvious without leaving the warm app palette.
    const maleAccent = Color(0xFF5C8FB8);
    const femaleAccent = Color(0xFFD98695);

    return _LabeledField(
      label: S.userProfileGenderLabel,
      delayMs: 440,
      child: Row(
        children: [
          Expanded(
            child: _GenderCard(
              label: S.userProfileMale,
              icon: Icons.male_rounded,
              accent: maleAccent,
              selected: _gender == UserGender.male,
              onTap: () => setState(() => _gender = UserGender.male),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _GenderCard(
              label: S.userProfileFemale,
              icon: Icons.female_rounded,
              accent: femaleAccent,
              selected: _gender == UserGender.female,
              onTap: () => setState(() => _gender = UserGender.female),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _saving ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepMoss.withValues(alpha: 0.85),
              AppColors.liquidGreen.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepMoss.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.userProfileContinue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 540.ms, duration: 450.ms)
        .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic);
  }
}

// ── Internal shared widgets ─────────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final int delayMs;
  const _LabeledField({
    required this.label,
    required this.child,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 400.ms)
        .moveY(begin: 10, end: 0, curve: Curves.easeOutCubic);
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.85),
                    accent.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? accent : Colors.white.withValues(alpha: 0.6),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? accent.withValues(alpha: 0.32)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: selected ? 18 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : accent.withValues(alpha: 0.14),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 28,
                color: selected ? Colors.white : accent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                height: 1.2,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Birth-date pill field ───────────────────────────────────────────────────

/// Read-only field that mirrors the visual style of [PillTextField] but acts
/// as a button — tapping it opens [_BirthDatePickerSheet]. Shows the picked
/// date in the user's locale, or a hint when empty. Switches to the error
/// accent if [showError] is true.
class _BirthDatePillField extends StatelessWidget {
  final DateTime? value;
  final bool showError;
  final String hint;
  final VoidCallback onTap;

  const _BirthDatePillField({
    required this.value,
    required this.showError,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = showError
        ? AppColors.error
        : Colors.white.withValues(alpha: 0.55);
    final hasValue = value != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: LiquidGlassCard(
              borderRadius: 50,
              padding: EdgeInsets.zero,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: accent,
                    width: showError ? 1.6 : 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softJade.withValues(alpha: 0.45),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.cake_outlined,
                        color: AppColors.deepMoss,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasValue ? _formatDate(value!) : hint,
                        style: TextStyle(
                          color: hasValue
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textHint,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 6),
              child: Text(
                S.fieldRequired,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const _monthsRu = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];
  static const _monthsEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) {
    final isRu = LocaleProvider.instance.isRu;
    if (isRu) {
      return '${d.day} ${_monthsRu[d.month - 1]} ${d.year} г.';
    }
    return '${_monthsEn[d.month - 1]} ${d.day}, ${d.year}';
  }
}

// ── Birth-date picker sheet ────────────────────────────────────────────────

/// Bottom-sheet host for a Cupertino wheel date picker, styled to match the
/// rest of the app: rounded top corners, soft mint backdrop, gradient
/// 'Done' pill that matches the primary CTAs.
class _BirthDatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;
  const _BirthDatePickerSheet({
    required this.initialDate,
    required this.minDate,
    required this.maxDate,
  });

  @override
  State<_BirthDatePickerSheet> createState() => _BirthDatePickerSheetState();
}

class _BirthDatePickerSheetState extends State<_BirthDatePickerSheet> {
  late DateTime _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final isRu = LocaleProvider.instance.isRu;
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.warmGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.deepMoss.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            // Header row
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    S.userProfileBirthDateCancel,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  S.userProfileAgeLabel,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 64), // visual balance for cancel button
              ],
            ),
            const SizedBox(height: 6),
            // The wheel itself, wrapped in a glass card.
            LiquidGlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 220,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: widget.initialDate,
                    minimumDate: widget.minDate,
                    maximumDate: widget.maxDate,
                    dateOrder: isRu
                        ? DatePickerDateOrder.dmy
                        : DatePickerDateOrder.mdy,
                    onDateTimeChanged: (d) => _picked = d,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Done button — matches the primary CTA style.
            GestureDetector(
              onTap: () => Navigator.of(context).pop(_picked),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepMoss.withValues(alpha: 0.85),
                      AppColors.liquidGreen.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepMoss.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  S.userProfileBirthDateConfirm,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
