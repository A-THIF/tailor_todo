import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class HomeHeaderBar extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeHeaderBar({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tailor Todo',
            style: AppFonts.spectral(
              color: AppColors.brandText,
              size: 24,
              weight: FontWeight.w300,
            ),
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.onDark,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColors.surface, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
