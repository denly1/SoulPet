import 'package:soulpet/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.avatarUrl,
    super.coins,
    super.onboardingDone,
    super.petTestDone,
    super.houseId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      onboardingDone: (json['onboarding_done'] as int?) == 1,
      petTestDone: (json['pet_test_done'] as int?) == 1,
      houseId: json['house_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'coins': coins,
      'onboarding_done': onboardingDone ? 1 : 0,
      'pet_test_done': petTestDone ? 1 : 0,
      'house_id': houseId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel.fromJson(map);
  Map<String, dynamic> toMap() => toJson();

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      coins: entity.coins,
      onboardingDone: entity.onboardingDone,
      petTestDone: entity.petTestDone,
      houseId: entity.houseId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
