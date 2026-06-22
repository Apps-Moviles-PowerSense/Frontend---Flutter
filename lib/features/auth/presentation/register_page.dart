import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/auth/presentation/register_state.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController email= TextEditingController();
  final TextEditingController password= TextEditingController();
  final TextEditingController name= TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegisterViewModel, RegisterState>(
          listener: (context, state) {
            // Si el estado es RegisterSuccess, mostramos un SnackBar de éxito y navegamos de regreso a la LoginPage
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('¡El usuario ha sido creado correctamente!')),
              );
              Navigator.pop(context);
            } 
            // Si el estado es RegisterFailure, mostramos un SnackBar con el mensaje de error
            else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children:[
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
                                    // Input de Nombre
                                    TextField(
                                      controller: name,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder( // El borde cuando le das clic
                                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                                        ),
                                        hintText: 'Nombre',
                                        prefixIcon: Icon(Icons.person_outline),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
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
                                    const SizedBox(height: 16),
                                    // Input de  confirmarContraseña
                                    TextField(
                                      controller: confirmPassword,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                                        ),
                                        hintText: 'Confirmar contraseña',
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
                                        onPressed: state is RegisterLoading? null
                                            : () {
                                                if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty || confirmPassword.text.isEmpty) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                                                  );
                                                  return;
                                                } 

                                                if (password.text != confirmPassword.text) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Las contraseñas no coinciden'),
                                                    backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                context.read<RegisterViewModel>().register(
                                                        email.text,
                                                        password.text,
                                                        name.text,
                                                      );
                                              },
                                        child: state is RegisterLoading? 
                                            const SizedBox(
                                                height: 24, width: 24,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : const Text('Registrarse', style: TextStyle(fontSize: 16)), 
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('¿Ya tienes cuenta? Inicia sesión', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(height: 32),
                                  ],)
                              )])
                      )
                    ));
                  }
                )
              ]
            );
          },
        ),
      ),
    );
  }
}