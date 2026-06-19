import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/domain/user.dart';
import 'package:power_sense/features/auth/presentation/login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginViewModel({required this.repository}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final User user = await repository.login(email, password);
      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}