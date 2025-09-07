import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 24, color: AppColors.brandText),
      ),
    );
  }
}
