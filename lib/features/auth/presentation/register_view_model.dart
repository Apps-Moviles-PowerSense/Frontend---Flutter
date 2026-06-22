import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/presentation/register_state.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  final AuthRepository repository;
  RegisterViewModel({required this.repository}) : super(RegisterInitial());

  Future<void> register(String email, String password, String name) async {
    emit(RegisterLoading());

    try {
      await repository.register(email, password, name);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(message: e.toString()));
    }
  }
}