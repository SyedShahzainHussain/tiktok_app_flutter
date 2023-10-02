import 'package:flutter/material.dart';
import 'package:tiktok/repository/app_colors.dart';

class TextInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscureText;
  final IconData icon;

  const TextInputForm(
      {super.key,
      required this.controller,
      required this.labelText,
       this.isObscureText = false,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: isObscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          labelStyle: const TextStyle(fontSize: 20),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
