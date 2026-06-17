import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/auth_entity.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call({
    required String email,
    required String password,
    required String username,
  }) {
    return _repository.register(
      email: email,
      password: password,
      username: username,
    );
  }
}
