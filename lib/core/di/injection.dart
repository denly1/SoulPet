import 'package:get_it/get_it.dart';
import 'package:soulpet/core/network/dio_client.dart';
import 'package:soulpet/core/storage/secure_storage.dart';
import 'package:soulpet/core/storage/local_database.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/data/datasources/local/pet_local_datasource.dart';
import 'package:soulpet/data/repositories/auth_repository_impl.dart';
import 'package:soulpet/data/repositories/pet_repository_impl.dart';
import 'package:soulpet/domain/repositories/auth_repository.dart';
import 'package:soulpet/domain/repositories/pet_repository.dart';
import 'package:soulpet/domain/usecases/auth/login_usecase.dart';
import 'package:soulpet/domain/usecases/auth/register_usecase.dart';
import 'package:soulpet/domain/usecases/auth/logout_usecase.dart';
import 'package:soulpet/domain/usecases/auth/reset_password_usecase.dart';
import 'package:soulpet/domain/usecases/pet/create_pet_usecase.dart';
import 'package:soulpet/domain/usecases/pet/get_pet_usecase.dart';
import 'package:soulpet/domain/usecases/pet/interact_with_pet_usecase.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingletonAsync<LocalDatabase>(
    () async {
      final db = LocalDatabase();
      await db.init();
      return db;
    },
  );
  await sl.isReady<LocalDatabase>();

  sl.registerLazySingleton<DioClient>(
    () => DioClient(secureStorage: sl<SecureStorage>()),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(sl<SecureStorage>()),
  );
  sl.registerLazySingleton<PetLocalDatasource>(
    () => PetLocalDatasource(sl<LocalDatabase>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDatasource: sl<AuthLocalDatasource>(),
      dioClient: sl<DioClient>(),
    ),
  );
  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(
      localDatasource: sl<PetLocalDatasource>(),
    ),
  );

  // Use cases — Auth
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl<AuthRepository>()));

  // Use cases — Pet
  sl.registerLazySingleton(() => CreatePetUseCase(sl<PetRepository>()));
  sl.registerLazySingleton(() => GetPetUseCase(sl<PetRepository>()));
  sl.registerLazySingleton(() => InteractWithPetUseCase(sl<PetRepository>()));
}
