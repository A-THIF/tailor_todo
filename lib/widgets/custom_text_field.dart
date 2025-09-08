import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType keyboard;
  final int maxLines; // ✅ add this as a member

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboard = TextInputType.text,
    this.maxLines = 1, // ✅ default value
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      maxLines: maxLines, // ✅ use it here
      decoration: InputDecoration(labelText: label),
    );
  }
}
