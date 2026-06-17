import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';

/// Persists pet-creation test progress and the final cat/dog tally.
///
/// State is kept across app restarts so users can resume a half-finished test
/// (ТЗ: "сохранение промежуточного состояния в случае вылета/закрытия
/// приложения"). Storage is cleared explicitly when the user confirms the pet
/// or chooses to retake the test.
class PetTestStorage {
  static const String _stateKey = 'pet_test_state';
  static const String _resultKey = 'pet_test_result';

  final SharedPreferences _prefs;

  PetTestStorage(this._prefs);

  Future<void> saveState(PetTestState state) async {
    await _prefs.setString(_stateKey, jsonEncode(state.toJson()));
  }

  PetTestState? loadState() {
    final raw = _prefs.getString(_stateKey);
    if (raw == null) return null;
    try {
      return PetTestState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearState() => _prefs.remove(_stateKey);

  Future<void> saveResult(TestResult result) async {
    final map = {
      'catScore': result.catScore,
      'dogScore': result.dogScore,
    };
    await _prefs.setString(_resultKey, jsonEncode(map));
  }

  TestResult? loadResult() {
    final raw = _prefs.getString(_resultKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return TestResult(
        catScore: (map['catScore'] as num?)?.toInt() ?? 0,
        dogScore: (map['dogScore'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearResult() => _prefs.remove(_resultKey);

  Future<void> clearAll() async {
    await clearState();
    await clearResult();
  }
}
