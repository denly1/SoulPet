import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Ошибка соединения с сервером']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({String message = 'Ошибка сервера', this.statusCode})
      : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Ошибка авторизации']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(
      [super.message = 'Неверный логин или пароль']);
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure(
      [super.message = 'Пользователь уже существует']);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure([super.message = 'Сессия истекла']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Ошибка кэша']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Что-то пошло не так']);
}
