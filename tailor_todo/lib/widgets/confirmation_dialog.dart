import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import 'custom_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Really want to delete this task?',
            style: AppFonts.cardo(
              color: AppColors.brandText,
              size: 16,
              weight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Return',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.onDark,
                  height: 44,
                  textStyle: AppFonts.cardo(
                    color: AppColors.onDark,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: 'Delete',
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: AppColors.onDark,
                  height: 44,
                  textStyle: AppFonts.cardo(
                    color: AppColors.onDark,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
