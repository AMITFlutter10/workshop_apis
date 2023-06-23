import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubit/main_cubit.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 50),
              BlocConsumer<MainCubit, MainState>(
                listener: (context, state) {
                  if (state is ErrorRegister) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message!)));
                  } else if (state is SuccessRegister) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Success")));

                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return state is LoadingRegister
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          onPressed: () {
                            MainCubit.get(context).register(
                                emailController.text,
                                passwordController.text,
                                phoneController.text,
                                nameController.text);
                          },
                          textColor: Colors.white,
                          color: Colors.deepOrange,
                          child: const Text("Register"),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
