import 'package:soulpet/domain/entities/pet_entity.dart';

class TestQuestion {
  final int id;
  final String text;
  final List<TestAnswer> answers;

  const TestQuestion({
    required this.id,
    required this.text,
    required this.answers,
  });
}

class TestAnswer {
  final int id;
  final String text;
  final Map<PetArchetype, int> scores;

  const TestAnswer({
    required this.id,
    required this.text,
    required this.scores,
  });
}

class TestResult {
  final PetArchetype archetype;
  final PetType suggestedType;
  final String description;
  final int totalScore;

  const TestResult({
    required this.archetype,
    required this.suggestedType,
    required this.description,
    required this.totalScore,
  });
}

class PetTestState {
  final int currentQuestionIndex;
  final Map<int, int> answers; // questionId -> answerId
  final bool isCompleted;

  const PetTestState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.isCompleted = false,
  });

  PetTestState copyWith({
    int? currentQuestionIndex,
    Map<int, int>? answers,
    bool? isCompleted,
  }) {
    return PetTestState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentQuestionIndex': currentQuestionIndex,
    'answers': answers.map((k, v) => MapEntry(k.toString(), v)),
    'isCompleted': isCompleted,
  };

  factory PetTestState.fromJson(Map<String, dynamic> json) {
    return PetTestState(
      currentQuestionIndex: json['currentQuestionIndex'] as int? ?? 0,
      answers: (json['answers'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(int.parse(k), v as int),
      ) ?? {},
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class PetTestData {
  static const List<TestQuestion> questions = [
    TestQuestion(
      id: 1,
      text: 'Как ты обычно проводишь свободное время?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Активно: спорт, прогулки, встречи с друзьями',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Спокойно: книги, фильмы, отдых дома',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 3,
          text: 'Изучаю что-то новое: курсы, хобби, эксперименты',
          scores: {PetArchetype.active: 1, PetArchetype.calm: 0, PetArchetype.curious: 3},
        ),
      ],
    ),
    TestQuestion(
      id: 2,
      text: 'Какой темп жизни тебе ближе?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Быстрый: много дел, постоянное движение',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Размеренный: всё по плану, без спешки',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 3,
          text: 'Переменчивый: зависит от настроения и интересов',
          scores: {PetArchetype.active: 1, PetArchetype.calm: 1, PetArchetype.curious: 2},
        ),
      ],
    ),
    TestQuestion(
      id: 3,
      text: 'Что тебя больше всего радует?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Достижения и победы',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Уют и гармония',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 0},
        ),
        TestAnswer(
          id: 3,
          text: 'Открытия и новые знания',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 1, PetArchetype.curious: 3},
        ),
      ],
    ),
    TestQuestion(
      id: 4,
      text: 'Как ты реагируешь на неожиданные ситуации?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Сразу действую, решаю проблему',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Сначала обдумываю, потом действую',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 3,
          text: 'Интересуюсь причинами, анализирую',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 1, PetArchetype.curious: 3},
        ),
      ],
    ),
    TestQuestion(
      id: 5,
      text: 'Какой питомец тебе ближе по духу?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Энергичный и игривый',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Спокойный и ласковый',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 0},
        ),
        TestAnswer(
          id: 3,
          text: 'Умный и наблюдательный',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 1, PetArchetype.curious: 3},
        ),
      ],
    ),
    TestQuestion(
      id: 6,
      text: 'Как ты предпочитаешь общаться?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Вживую, с эмоциями и жестами',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Спокойно, один на один',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 0},
        ),
        TestAnswer(
          id: 3,
          text: 'Обсуждая интересные темы и идеи',
          scores: {PetArchetype.active: 1, PetArchetype.calm: 0, PetArchetype.curious: 3},
        ),
      ],
    ),
    TestQuestion(
      id: 7,
      text: 'Что для тебя важнее в отношениях?',
      answers: [
        TestAnswer(
          id: 1,
          text: 'Совместные приключения и активности',
          scores: {PetArchetype.active: 3, PetArchetype.calm: 0, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 2,
          text: 'Взаимопонимание и поддержка',
          scores: {PetArchetype.active: 0, PetArchetype.calm: 3, PetArchetype.curious: 1},
        ),
        TestAnswer(
          id: 3,
          text: 'Общие интересы и развитие',
          scores: {PetArchetype.active: 1, PetArchetype.calm: 0, PetArchetype.curious: 3},
        ),
      ],
    ),
  ];

  static TestResult calculateResult(Map<int, int> answers) {
    final scores = <PetArchetype, int>{
      PetArchetype.active: 0,
      PetArchetype.calm: 0,
      PetArchetype.curious: 0,
    };

    for (final entry in answers.entries) {
      final question = questions.firstWhere((q) => q.id == entry.key);
      final answer = question.answers.firstWhere((a) => a.id == entry.value);
      
      for (final scoreEntry in answer.scores.entries) {
        scores[scoreEntry.key] = (scores[scoreEntry.key] ?? 0) + scoreEntry.value;
      }
    }

    final maxEntry = scores.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );

    final archetype = maxEntry.key;
    final totalScore = maxEntry.value;

    // Определяем тип питомца на основе архетипа
    final suggestedType = archetype == PetArchetype.active 
        ? PetType.dog 
        : PetType.cat;

    final description = _getArchetypeDescription(archetype);

    return TestResult(
      archetype: archetype,
      suggestedType: suggestedType,
      description: description,
      totalScore: totalScore,
    );
  }

  static String _getArchetypeDescription(PetArchetype archetype) {
    switch (archetype) {
      case PetArchetype.active:
        return 'Тебе подойдёт активный и энергичный питомец! '
            'Он будет рад играть с тобой, бегать и веселиться. '
            'Вместе вы точно не заскучаете!';
      case PetArchetype.calm:
        return 'Тебе подойдёт спокойный и ласковый питомец! '
            'Он будет рядом в моменты отдыха, создавая уют и гармонию. '
            'Идеальный компаньон для релакса.';
      case PetArchetype.curious:
        return 'Тебе подойдёт любознательный и умный питомец! '
            'Он будет исследовать мир вместе с тобой и удивлять своими открытиями. '
            'Скучно точно не будет!';
    }
  }

  static String getArchetypeLabel(PetArchetype archetype) {
    switch (archetype) {
      case PetArchetype.active:
        return 'Активный';
      case PetArchetype.calm:
        return 'Спокойный';
      case PetArchetype.curious:
        return 'Любознательный';
    }
  }

  static String getArchetypeEmoji(PetArchetype archetype) {
    switch (archetype) {
      case PetArchetype.active:
        return '⚡';
      case PetArchetype.calm:
        return '🌙';
      case PetArchetype.curious:
        return '🔍';
    }
  }
}
