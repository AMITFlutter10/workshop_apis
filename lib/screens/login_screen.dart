import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_apis/cubits/cubit/main_cubit.dart';
import 'package:workshop_apis/models/login_response_model.dart';
import 'package:workshop_apis/screens/home_screen.dart';
import 'package:workshop_apis/screens/register_screen.dart';
import 'package:workshop_apis/utils/dio_helper.dart';
import 'package:workshop_apis/utils/end_points.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                if (state is ErrorLogin) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message!)));
                } else if (state is SuccessLogin) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Success")));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return state is LoadingLogin
                    ? const Center(child: CircularProgressIndicator())
                    : MaterialButton(
                        onPressed: () {
                          MainCubit.get(context).login(
                              emailController.text, passwordController.text);
                        },
                        textColor: Colors.white,
                        color: Colors.deepOrange,
                        child: const Text("Login"),
                      );
              },
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Create Account"),
            )
          ],
        ),
      ),
    );
  }
}
