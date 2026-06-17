import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/repositories/pet_repository.dart';

class CreatePetUseCase {
  final PetRepository _repository;
  const CreatePetUseCase(this._repository);

  Future<Either<Failure, PetEntity>> call({
    required String userId,
    required String name,
    required PetType type,
    required PetArchetype archetype,
    required PetGender gender,
    required String houseId,
  }) {
    return _repository.createPet(
      userId: userId,
      name: name,
      type: type,
      archetype: archetype,
      gender: gender,
      houseId: houseId,
    );
  }
}
