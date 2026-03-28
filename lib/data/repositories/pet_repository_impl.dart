import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/data/datasources/local/pet_local_datasource.dart';
import 'package:soulpet/data/models/pet_model.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/repositories/pet_repository.dart';
import 'package:uuid/uuid.dart';

class PetRepositoryImpl implements PetRepository {
  final PetLocalDatasource localDatasource;

  const PetRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, PetEntity>> createPet({
    required String userId,
    required String name,
    required PetType type,
    required PetArchetype archetype,
    required PetGender gender,
    required String houseId,
  }) async {
    try {
      final now = DateTime.now();
      final pet = PetModel(
        id: const Uuid().v4(),
        userId: userId,
        name: name,
        type: type,
        archetype: archetype,
        gender: gender,
        stage: PetStage.baby,
        level: 1,
        experience: 0,
        hunger: 100,
        energy: 100,
        happiness: 100,
        mood: 100,
        currentAction: PetAction.idle,
        houseId: houseId,
        createdAt: now,
        updatedAt: now,
      );
      final saved = await localDatasource.insertPet(pet);
      return Right(saved);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PetEntity?>> getPetByUserId(String userId) async {
    try {
      final pet = await localDatasource.getPetByUserId(userId);
      return Right(pet);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PetEntity>> updatePet(PetEntity pet) async {
    try {
      final updated = await localDatasource.updatePet(PetModel.fromEntity(pet));
      return Right(updated);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PetEntity>> interactWithPet({
    required String petId,
    required PetInteractionType interaction,
  }) async {
    try {
      final pet = await localDatasource.getPetById(petId);
      if (pet == null) {
        return const Left(UnknownFailure('Питомец не найден'));
      }

      PetModel updated;
      final now = DateTime.now();

      switch (interaction) {
        case PetInteractionType.feed:
          updated = PetModel.fromEntity(pet.copyWith(
            hunger: (pet.hunger + 30).clamp(0, 100),
            updatedAt: now,
          ));
          break;
        case PetInteractionType.stroke:
          updated = PetModel.fromEntity(pet.copyWith(
            happiness: (pet.happiness + 20).clamp(0, 100),
            mood: (pet.mood + 15).clamp(0, 100),
            updatedAt: now,
          ));
          break;
        case PetInteractionType.play:
          updated = PetModel.fromEntity(pet.copyWith(
            happiness: (pet.happiness + 25).clamp(0, 100),
            energy: (pet.energy - 10).clamp(0, 100),
            updatedAt: now,
          ));
          break;
        case PetInteractionType.wash:
          updated = PetModel.fromEntity(pet.copyWith(
            mood: (pet.mood + 20).clamp(0, 100),
            updatedAt: now,
          ));
          break;
      }

      final saved = await localDatasource.updatePet(updated);
      return Right(saved);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PetEntity>> tickPetStats(String petId) async {
    try {
      final pet = await localDatasource.getPetById(petId);
      if (pet == null) {
        return const Left(UnknownFailure('Питомец не найден'));
      }

      final now = DateTime.now();
      final updated = PetModel.fromEntity(pet.copyWith(
        hunger: (pet.hunger - 2).clamp(0, 100),
        energy: (pet.energy - 1).clamp(0, 100),
        updatedAt: now,
      ));

      final saved = await localDatasource.updatePet(updated);
      return Right(saved);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
