import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
