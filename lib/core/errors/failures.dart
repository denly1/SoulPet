import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Ошибка соединения с сервером'])
      : super(message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({String message = 'Ошибка сервера', this.statusCode})
      : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Ошибка авторизации']) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(
      [String message = 'Неверный логин или пароль'])
      : super(message);
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure(
      [String message = 'Пользователь уже существует'])
      : super(message);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure([String message = 'Сессия истекла']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Ошибка кэша']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Что-то пошло не так'])
      : super(message);
}
