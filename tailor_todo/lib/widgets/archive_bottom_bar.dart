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
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Text(
                  'Archived',
                  style: AppFonts.spectral(
                    color: AppColors.brandText,
                    size: 18,
                    weight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isArchived ? AppColors.accent : Colors.transparent,
                    border: Border.all(color: AppColors.accent, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isArchived
                      ? Icon(Icons.check, color: AppColors.surface, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
