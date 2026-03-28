import 'package:dartz/dartz.dart';
import 'package:soulpet/core/errors/exceptions.dart';
import 'package:soulpet/core/errors/failures.dart';
import 'package:soulpet/core/network/dio_client.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/data/models/user_model.dart';
import 'package:soulpet/domain/entities/auth_entity.dart';
import 'package:soulpet/domain/entities/user_entity.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final DioClient dioClient;

  const AuthRepositoryImpl({
    required this.localDatasource,
    required this.dioClient,
  });

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Replace with real API call in Block 4 (Network)
      // Stub: local login simulation
      await Future.delayed(const Duration(milliseconds: 800));

      final fakeUserId = const Uuid().v4();
      final fakeAccess = 'access_${fakeUserId}';
      final fakeRefresh = 'refresh_${fakeUserId}';

      await localDatasource.saveTokens(
        accessToken: fakeAccess,
        refreshToken: fakeRefresh,
        userId: fakeUserId,
      );

      return Right(AuthTokens(
        accessToken: fakeAccess,
        refreshToken: fakeRefresh,
        userId: fakeUserId,
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // TODO: Replace with real API call in Block 4 (Network)
      await Future.delayed(const Duration(milliseconds: 800));

      final fakeUserId = const Uuid().v4();
      final fakeAccess = 'access_$fakeUserId';
      final fakeRefresh = 'refresh_$fakeUserId';

      await localDatasource.saveTokens(
        accessToken: fakeAccess,
        refreshToken: fakeRefresh,
        userId: fakeUserId,
      );

      return Right(AuthTokens(
        accessToken: fakeAccess,
        refreshToken: fakeRefresh,
        userId: fakeUserId,
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      // TODO: Replace with real API call in Block 4 (Network)
      await Future.delayed(const Duration(milliseconds: 600));
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      // TODO: Implement token refresh in Block 4
      return const Left(TokenExpiredFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userId = await localDatasource.getUserId();
      if (userId == null) return const Left(AuthFailure());

      final now = DateTime.now();
      return Right(UserModel(
        id: userId,
        email: 'user@soulpet.app',
        username: 'SoulPetUser',
        coins: 100,
        createdAt: now,
        updatedAt: now,
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localDatasource.hasValidSession();
  }
}
