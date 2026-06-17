import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/profile/user_profile_provider.dart';
import 'package:soulpet/domain/entities/user_profile_entity.dart';

/// Locale- and gender-aware copy for the personality test.
///
/// Kept in a single file so adding/removing a question is a one-stop edit.
/// Each question exposes:
///   * [text]    — the prompt
///   * [textA]   — A-option (cat-leaning)
///   * [textB]   — B-option (dog-leaning)
class PetTestQuestionStrings {
  final String text;
  final String textA;
  final String textB;
  const PetTestQuestionStrings({
    required this.text,
    required this.textA,
    required this.textB,
  });
}

class PetTestStrings {
  PetTestStrings._();

  static bool get _isRu => LocaleProvider.instance.isRu;
  static UserGender get _gender => UserProfileProvider.instance.gender;

  /// 6 questions, indexed by id (1-based as in [PetTestData.questions]).
  static List<PetTestQuestionStrings> get questions => _isRu ? _ru : _en;

  /// Lookup a localized question by its 1-based id; falls back to index 0
  /// when the id is out of range so the UI never crashes.
  static PetTestQuestionStrings byId(int id) {
    final list = questions;
    if (id < 1 || id > list.length) return list.first;
    return list[id - 1];
  }

  // ─── Russian copy ───────────────────────────────────────────────────────

  static List<PetTestQuestionStrings> get _ru {
    // Question 5 has a verb that depends on the *user's* gender:
    //   male   → "Готов уделять..."
    //   female → "Готова уделять..."
    final readyToCare = UserProfileProvider.instance.pick(
      male: 'Готов уделять больше времени заботе и активности',
      female: 'Готова уделять больше времени заботе и активности',
      neutral: 'Готов(а) уделять больше времени заботе и активности',
    );

    return [
      const PetTestQuestionStrings(
        text: 'Как тебе комфортнее проводить свободное время?',
        textA: 'Спокойно дома, в уютной атмосфере',
        textB: 'Активно, гулять, встречаться, что-то делать',
      ),
      const PetTestQuestionStrings(
        text: 'Какой характер питомца тебе ближе?',
        textA: 'Независимый, спокойный, с характером',
        textB: 'Общительный, энергичный, дружелюбный',
      ),
      const PetTestQuestionStrings(
        text: 'Что тебе приятнее в общении с питомцем?',
        textA: 'Когда он рядом, но не требует слишком много внимания',
        textB: 'Когда он активно вовлекает меня в игру и контакт',
      ),
      const PetTestQuestionStrings(
        text: 'Какой ритм жизни тебе ближе?',
        textA: 'Размеренный и предсказуемый',
        textB: 'Подвижный и насыщенный',
      ),
      PetTestQuestionStrings(
        text: 'Как ты относишься к уходу за питомцем?',
        textA: 'Хочу более самостоятельного питомца',
        textB: readyToCare,
      ),
      const PetTestQuestionStrings(
        text: 'Как ты реагируешь на новое и неожиданное?',
        textA: 'Сначала наблюдаю и привыкаю, доверяю не сразу',
        textB: 'Быстро включаюсь и радуюсь всему новому',
      ),
    ];
  }

  // ─── English copy ───────────────────────────────────────────────────────

  static List<PetTestQuestionStrings> get _en {
    // English has no gendered verb forms, but we still keep the structure
    // symmetrical so the question layout stays in sync between languages.
    // ignore: unused_local_variable
    final _ = _gender;

    return const [
      PetTestQuestionStrings(
        text: 'How do you prefer to spend your free time?',
        textA: 'Quietly at home, in a cozy atmosphere',
        textB: 'Actively — walks, meeting people, doing things',
      ),
      PetTestQuestionStrings(
        text: 'Which pet temperament feels closer to you?',
        textA: 'Independent, calm, with character',
        textB: 'Sociable, energetic, friendly',
      ),
      PetTestQuestionStrings(
        text: 'What do you enjoy most when interacting with a pet?',
        textA: 'When they\'re nearby but don\'t demand too much attention',
        textB: 'When they actively pull me into play and contact',
      ),
      PetTestQuestionStrings(
        text: 'Which life rhythm suits you best?',
        textA: 'Steady and predictable',
        textB: 'Dynamic and full of motion',
      ),
      PetTestQuestionStrings(
        text: 'How do you feel about caring for a pet?',
        textA: 'I\'d like a more self-sufficient companion',
        textB: 'I\'m ready to spend more time on care and activity',
      ),
      PetTestQuestionStrings(
        text: 'How do you react to new and unexpected things?',
        textA: 'I observe and get used to them, trust takes time',
        textB: 'I jump in quickly and enjoy everything new',
      ),
    ];
  }
}
