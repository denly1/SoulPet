import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/domain/entities/auth_entity.dart';
import 'package:soulpet/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<bool> isLoggedIn();
}
