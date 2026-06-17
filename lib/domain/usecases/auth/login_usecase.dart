import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/auth_entity.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
