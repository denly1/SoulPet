import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';

abstract class PetRepository {
  Future<Either<Failure, PetEntity>> createPet({
    required String userId,
    required String name,
    required PetType type,
    required PetArchetype archetype,
    required PetGender gender,
    required String houseId,
  });

  Future<Either<Failure, PetEntity?>> getPetByUserId(String userId);

  Future<Either<Failure, PetEntity>> updatePet(PetEntity pet);

  Future<Either<Failure, PetEntity>> interactWithPet({
    required String petId,
    required PetInteractionType interaction,
  });

  Future<Either<Failure, PetEntity>> tickPetStats(String petId);
}

enum PetInteractionType { feed, stroke, play, wash }
