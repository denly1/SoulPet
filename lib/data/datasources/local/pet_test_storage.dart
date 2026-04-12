import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/entities/pet_test_entity.dart';

class PetTestStorage {
  static const String _stateKey = 'pet_test_state';
  static const String _resultKey = 'pet_test_result';

  final SharedPreferences _prefs;

  PetTestStorage(this._prefs);

  Future<void> saveState(PetTestState state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString(_stateKey, json);
  }

  PetTestState? loadState() {
    final json = _prefs.getString(_stateKey);
    if (json == null) return null;
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PetTestState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearState() async {
    await _prefs.remove(_stateKey);
  }

  Future<void> saveResult(TestResult result) async {
    final map = {
      'archetype': result.archetype.name,
      'suggestedType': result.suggestedType.name,
      'description': result.description,
      'totalScore': result.totalScore,
    };
    await _prefs.setString(_resultKey, jsonEncode(map));
  }

  TestResult? loadResult() {
    final json = _prefs.getString(_resultKey);
    if (json == null) return null;
    
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return TestResult(
        archetype: _parseArchetype(map['archetype'] as String),
        suggestedType: _parseType(map['suggestedType'] as String),
        description: map['description'] as String,
        totalScore: map['totalScore'] as int,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearResult() async {
    await _prefs.remove(_resultKey);
  }

  Future<void> clearAll() async {
    await clearState();
    await clearResult();
  }

  static PetArchetype _parseArchetype(String value) {
    return PetArchetype.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetArchetype.calm,
    );
  }

  static PetType _parseType(String value) {
    return PetType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetType.cat,
    );
  }
}
