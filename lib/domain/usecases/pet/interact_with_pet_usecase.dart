import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/repositories/pet_repository.dart';

class InteractWithPetParams {
  final String petId;
  final PetInteractionType interaction;
  const InteractWithPetParams({
    required this.petId,
    required this.interaction,
  });
}

class InteractWithPetUseCase {
  final PetRepository _repository;
  const InteractWithPetUseCase(this._repository);

  Future<Either<Failure, PetEntity>> call(InteractWithPetParams params) {
    return _repository.interactWithPet(
      petId: params.petId,
      interaction: params.interaction,
    );
  }
}
