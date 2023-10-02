import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/provider/auth_proivder.dart';
import 'package:tiktok/repository/app_colors.dart';
import 'package:tiktok/view/screen/auth/login_screen.dart';
import 'package:tiktok/view/screen/auth/widget/text_form_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TikTok Clone",
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  authProvider.imagePath != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: FileImage(
                            File(context.read<AuthProvider>().imagePath!.path),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundColor: AppColors.borderColor,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {
                          authProvider.pickImage(context);
                        },
                        icon: const Icon(Icons.camera_alt_outlined)),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextInputForm(
                controller: _usernameController,
                icon: Icons.person,
                labelText: "Username",
              ),
              const SizedBox(
                height: 15,
              ),
              TextInputForm(
                controller: _emailController,
                icon: Icons.email,
                labelText: "Email",
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputForm(
                controller: _passwordController,
                icon: Icons.lock,
                labelText: "Password",
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  authProvider.register(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    context.read<AuthProvider>().imagePath,
                    context,
                  );
                  
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
