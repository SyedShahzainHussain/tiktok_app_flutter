import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/provider/auth_proivder.dart';
import 'package:tiktok/repository/app_colors.dart';
import 'package:tiktok/view/screen/auth/register_screen.dart';
import 'package:tiktok/view/screen/auth/widget/text_form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
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
                "Login",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
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
                  authProvider.login(
                    _emailController.text,
                    _passwordController.text,
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
                    child: authProvider.isLoginLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text(
                            "Login",
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
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "Register",
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
