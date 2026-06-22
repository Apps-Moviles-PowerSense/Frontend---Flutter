import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/auth/presentation/login_state.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/main/presentation/main_page.dart';
import 'package:power_sense/features/auth/presentation/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginViewModel, LoginState>(
          listener: (context, state) {

            // Si el estado es LoginSuccess, navegamos a la MainPage
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            }

            // Si el estado es LoginFailure, mostramos un SnackBar con el mensaje de error
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade600,
                ),
              );
            }
          },
        builder: (context, state) {
          return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              // Logo en la parte superior centro
                              SizedBox(
                                height: constraints.maxHeight * 0.5, 
                                child: Center(
                                  child: Image.asset(
                                    'assets/logo/LogoPowerSense.png',
                                    height: 150,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Input de Correo
                                    TextField(
                                      controller: email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder( // El borde cuando le das clic
                                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                                        ),
                                        hintText: 'Correo electrónico',
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Input de Contraseña
                                    TextField(
                                      controller: password,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                                        ),
                                        hintText: 'Contraseña',
                                        prefixIcon: Icon(Icons.lock_outline),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      height: 50,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          ),
                                        onPressed: state is LoginLoading? null
                                            : () {
                                                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                                                  context.read<LoginViewModel>().login(
                                                        email.text,
                                                        password.text,
                                                      );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Por favor, completa ambos campos')),
                                                  );
                                                }
                                              },
                                        child: state is LoginLoading? 
                                            const SizedBox(
                                                height: 24, width: 24,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            : const Text('Ingresar', style: TextStyle(fontSize: 16)),
                                            
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    TextButton(
                                      onPressed: state is LoginLoading 
                                          ? null
                                          : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => RegisterPage()),
                                              );
                                            },
                                      child: const Text(
                                        '¿No tienes una cuenta? Regístrate aquí',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (state is LoginLoading)
                  Container(color: Colors.black12),
              ],
            );
          },
        ),
      ),
    );
  }
}
