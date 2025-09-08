import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class ArchiveBottomBar extends StatelessWidget {
  final bool isArchived;
  final VoidCallback onTap;

  const ArchiveBottomBar({
    super.key,
    required this.isArchived,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        alignment: Alignment.bottomCenter, // stick to bottom
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 200, // fixed smaller width
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Archived',
                    style: AppFonts.spectral(
                      color: const Color(0xFFF1AA9B),
                      size: 16,
                      weight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.folder_rounded,
                    size: 18,
                    color: isArchived
                        ? const Color(0xFFF1AA9B)
                        : AppColors.onDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
