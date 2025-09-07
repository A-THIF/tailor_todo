import 'package:flutter/material.dart';
import '../utils/fonts.dart';
import '../utils/colors.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final bool showProfile;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onProfileTap; // Add this

  const HeaderBar({
    super.key,
    required this.title,
    this.showProfile = false,
    this.showBack = false,
    this.onBack,
    this.onProfileTap, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          // circular back button
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                title,
                style: AppFonts.spectral(
                  color: AppColors.brandText,
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        if (showProfile) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfileTap ?? () {}, // Use onProfileTap callback
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              radius: 20,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
