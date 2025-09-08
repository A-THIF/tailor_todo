import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TodoDetailsActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoDetailsActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.white),
      color: AppColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade400, width: 1),
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }
}
