import 'package:flutter/material.dart';
import 'package:soulpet/core/l10n/pet_test_strings.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';

// Identifier for which answer option a user picked: A or B.
enum TestOption { a, b }

extension TestOptionX on TestOption {
  String get code => this == TestOption.a ? 'A' : 'B';
  static TestOption fromCode(String code) =>
      code == 'B' ? TestOption.b : TestOption.a;
}

class TestAnswer {
  final String text;
  final IconData icon;
  final PetType favors; // cat or dog
  const TestAnswer({
    required this.text,
    required this.icon,
    required this.favors,
  });
}

class TestQuestion {
  final int id;
  final String text;
  final TestAnswer answerA;
  final TestAnswer answerB;

  const TestQuestion({
    required this.id,
    required this.text,
    required this.answerA,
    required this.answerB,
  });

  TestAnswer answerFor(TestOption o) =>
      o == TestOption.a ? answerA : answerB;
}

/// Static layout of every question — only the parts that don't depend on
/// language: id, icons and which pet each option favors. The actual prompt and
/// answer copy is filled in lazily from [PetTestStrings] inside
/// [PetTestData.questions], so switching language re-localizes the test
/// without restarting it.
class _QuestionShape {
  final int id;
  final IconData iconA;
  final IconData iconB;
  const _QuestionShape({
    required this.id,
    required this.iconA,
    required this.iconB,
  });
}

/// Result of the personality test. Tie is represented by [catScore] == [dogScore].
class TestResult {
  final int catScore;
  final int dogScore;

  const TestResult({required this.catScore, required this.dogScore});

  bool get isTie => catScore == dogScore;

  /// Winning pet type. `null` if it's a tie.
  PetType? get suggestedType {
    if (catScore > dogScore) return PetType.cat;
    if (dogScore > catScore) return PetType.dog;
    return null;
  }

  /// Archetype derived from the resulting pet type (for [PetEntity]).
  /// Cat → calm, Dog → active. On tie defaults to calm.
  PetArchetype get archetype {
    switch (suggestedType) {
      case PetType.dog:
        return PetArchetype.active;
      case PetType.cat:
      case null:
        return PetArchetype.calm;
    }
  }

  int get totalScore => catScore + dogScore;
}

/// Progress & answers captured during the test. Persisted between launches so
/// that users who close the app mid-test can resume.
class PetTestState {
  final int currentQuestionIndex;
  // questionId -> 0 for A / 1 for B (TestOption.index)
  final Map<int, int> answers;
  final bool isCompleted;

  const PetTestState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.isCompleted = false,
  });

  TestOption? optionFor(int questionId) {
    final raw = answers[questionId];
    if (raw == null) return null;
    return raw == TestOption.b.index ? TestOption.b : TestOption.a;
  }

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
          ) ??
          {},
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

/// Static, finite personality test used during pet creation.
///
/// Every answer of variant A scores 1 point for a cat; every answer of variant
/// B scores 1 point for a dog. On a tie the UI offers a manual choice.
class PetTestData {
  // Icons + favors are language-independent and live here. Prompts and answer
  // copy are pulled from [PetTestStrings] on every read so switching the app
  // language (or filling in the user gender) immediately re-localizes the
  // test, no restart required.
  static const List<_QuestionShape> _shapes = [
    _QuestionShape(
      id: 1,
      iconA: Icons.home_rounded,
      iconB: Icons.directions_walk_rounded,
    ),
    _QuestionShape(
      id: 2,
      iconA: Icons.nightlight_round,
      iconB: Icons.favorite_rounded,
    ),
    _QuestionShape(
      id: 3,
      iconA: Icons.self_improvement_rounded,
      iconB: Icons.sports_esports_rounded,
    ),
    _QuestionShape(
      id: 4,
      iconA: Icons.schedule_rounded,
      iconB: Icons.directions_bike_rounded,
    ),
    _QuestionShape(
      id: 5,
      iconA: Icons.ramen_dining_rounded,
      iconB: Icons.volunteer_activism_rounded,
    ),
    _QuestionShape(
      id: 6,
      iconA: Icons.remove_red_eye_rounded,
      iconB: Icons.celebration_rounded,
    ),
  ];

  /// Localized list of test questions. Rebuilt on every access — cheap, since
  /// it just re-wraps a handful of strings — so changing language between two
  /// frames is reflected instantly.
  static List<TestQuestion> get questions {
    return _shapes.map((s) {
      final str = PetTestStrings.byId(s.id);
      return TestQuestion(
        id: s.id,
        text: str.text,
        answerA: TestAnswer(
          text: str.textA,
          icon: s.iconA,
          favors: PetType.cat,
        ),
        answerB: TestAnswer(
          text: str.textB,
          icon: s.iconB,
          favors: PetType.dog,
        ),
      );
    }).toList(growable: false);
  }

  /// Tallies answers (A = +1 cat, B = +1 dog) into a [TestResult].
  static TestResult calculateResult(Map<int, int> answers) {
    int cat = 0;
    int dog = 0;
    for (final raw in answers.values) {
      if (raw == TestOption.a.index) {
        cat++;
      } else if (raw == TestOption.b.index) {
        dog++;
      }
    }
    return TestResult(catScore: cat, dogScore: dog);
  }

  static String typeLabel(PetType type) =>
      type == PetType.cat ? 'Кот' : 'Собака';
}
