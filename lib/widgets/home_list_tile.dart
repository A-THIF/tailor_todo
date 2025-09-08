// TODO Implement this library.
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final bool showArchived;

  const TodoListTile({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onDelete,
    required this.onArchive,
    required this.showArchived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: AppFonts.cardo(
                      color: AppColors.onDark,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.onDark,
                    size: 20,
                  ),
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.accent, width: 1),
                  ),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    } else if (value == 'archive') {
                      onArchive();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'archive',
                      child: Text(
                        showArchived ? 'Unarchive' : 'Archive',
                        style: AppFonts.cardo(color: AppColors.onDark),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: AppFonts.cardo(color: AppColors.brandRed),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
