import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({required String email}) {
    return _repository.resetPassword(email: email);
  }
}
