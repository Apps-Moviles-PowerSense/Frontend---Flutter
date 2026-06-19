import 'package:power_sense/features/auth/domain/user.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure({required this.message});
}