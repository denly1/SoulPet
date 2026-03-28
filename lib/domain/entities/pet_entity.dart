import 'package:equatable/equatable.dart';

enum PetType { cat, dog }

enum PetArchetype { active, calm, curious }

enum PetGender { male, female }

enum PetStage { baby, teen, adult }

enum PetAction {
  idle,
  walking,
  sitting,
  sleeping,
  eating,
  playing,
  exploring,
  lookingOutWindow,
  watchingTV,
  observingFly,
  stretching,
  grooming,
  running,
  lying,
  thinkingDeep,
  pawingObject,
  spinning,
  sniffing,
  yawning,
  jumpingAround,
}

class PetEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final PetType type;
  final PetArchetype archetype;
  final PetGender gender;
  final PetStage stage;
  final int level;
  final int experience;
  final int hunger;
  final int energy;
  final int happiness;
  final int mood;
  final PetAction currentAction;
  final String? houseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PetEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.archetype,
    required this.gender,
    this.stage = PetStage.baby,
    this.level = 1,
    this.experience = 0,
    this.hunger = 100,
    this.energy = 100,
    this.happiness = 100,
    this.mood = 100,
    this.currentAction = PetAction.idle,
    this.houseId,
    required this.createdAt,
    required this.updatedAt,
  });

  PetEntity copyWith({
    String? id,
    String? userId,
    String? name,
    PetType? type,
    PetArchetype? archetype,
    PetGender? gender,
    PetStage? stage,
    int? level,
    int? experience,
    int? hunger,
    int? energy,
    int? happiness,
    int? mood,
    PetAction? currentAction,
    String? houseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PetEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      archetype: archetype ?? this.archetype,
      gender: gender ?? this.gender,
      stage: stage ?? this.stage,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      mood: mood ?? this.mood,
      currentAction: currentAction ?? this.currentAction,
      houseId: houseId ?? this.houseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isHungry => hunger < 30;
  bool get isTired => energy < 30;
  bool get isUnhappy => happiness < 30;

  String get stageLabel {
    switch (stage) {
      case PetStage.baby:
        return 'Малыш';
      case PetStage.teen:
        return 'Подросток';
      case PetStage.adult:
        return 'Взрослый';
    }
  }

  String get typeLabel {
    switch (type) {
      case PetType.cat:
        return 'Кот';
      case PetType.dog:
        return 'Собака';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        archetype,
        gender,
        stage,
        level,
        experience,
        hunger,
        energy,
        happiness,
        mood,
        currentAction,
        houseId,
        createdAt,
        updatedAt,
      ];
}
