import 'package:soulpet/domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  const PetModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.archetype,
    required super.gender,
    super.stage,
    super.level,
    super.experience,
    super.hunger,
    super.energy,
    super.happiness,
    super.mood,
    super.currentAction,
    super.houseId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: _parseType(json['type'] as String),
      archetype: _parseArchetype(json['archetype'] as String),
      gender: _parseGender(json['gender'] as String),
      stage: _parseStage(json['stage'] as String? ?? 'baby'),
      level: (json['level'] as num?)?.toInt() ?? 1,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      hunger: (json['hunger'] as num?)?.toInt() ?? 100,
      energy: (json['energy'] as num?)?.toInt() ?? 100,
      happiness: (json['happiness'] as num?)?.toInt() ?? 100,
      mood: (json['mood'] as num?)?.toInt() ?? 100,
      currentAction: _parseAction(json['current_action'] as String? ?? 'idle'),
      houseId: json['house_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type.name,
      'archetype': archetype.name,
      'gender': gender.name,
      'stage': stage.name,
      'level': level,
      'experience': experience,
      'hunger': hunger,
      'energy': energy,
      'happiness': happiness,
      'mood': mood,
      'current_action': currentAction.name,
      'house_id': houseId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) => PetModel.fromJson(map);
  Map<String, dynamic> toMap() => toJson();

  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      type: entity.type,
      archetype: entity.archetype,
      gender: entity.gender,
      stage: entity.stage,
      level: entity.level,
      experience: entity.experience,
      hunger: entity.hunger,
      energy: entity.energy,
      happiness: entity.happiness,
      mood: entity.mood,
      currentAction: entity.currentAction,
      houseId: entity.houseId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static PetType _parseType(String value) {
    return PetType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetType.cat,
    );
  }

  static PetArchetype _parseArchetype(String value) {
    return PetArchetype.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetArchetype.calm,
    );
  }

  static PetGender _parseGender(String value) {
    return PetGender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetGender.male,
    );
  }

  static PetStage _parseStage(String value) {
    return PetStage.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetStage.baby,
    );
  }

  static PetAction _parseAction(String value) {
    return PetAction.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PetAction.idle,
    );
  }
}
