import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final int coins;
  final bool onboardingDone;
  final bool petTestDone;
  final String? houseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.coins = 0,
    this.onboardingDone = false,
    this.petTestDone = false,
    this.houseId,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    int? coins,
    bool? onboardingDone,
    bool? petTestDone,
    String? houseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coins: coins ?? this.coins,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      petTestDone: petTestDone ?? this.petTestDone,
      houseId: houseId ?? this.houseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        avatarUrl,
        coins,
        onboardingDone,
        petTestDone,
        houseId,
        createdAt,
        updatedAt,
      ];
}
