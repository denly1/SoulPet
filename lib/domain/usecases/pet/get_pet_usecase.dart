import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/pet_entity.dart';
import 'package:soulpet/domain/repositories/pet_repository.dart';

class GetPetUseCase {
  final PetRepository _repository;
  const GetPetUseCase(this._repository);

  Future<Either<Failure, PetEntity?>> call(String userId) {
    return _repository.getPetByUserId(userId);
  }
}
