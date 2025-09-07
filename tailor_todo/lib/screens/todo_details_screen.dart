import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Todo todo;

  const TodoDetailsScreen({super.key, required this.todo});

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  final supabase = Supabase.instance.client;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isEditing = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTodo() async {
    setState(() => loading = true);

    try {
      await supabase
          .from('todos')
          .update({
            'title': titleController.text.trim(),
            'description': descriptionController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', widget.todo.id);

      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating task: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _deleteTodo() async {
    try {
      await supabase.from('todos').delete().eq('id', widget.todo.id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting task: $e')));
    }
  }

  String _formatDuration() {
    final now = DateTime.now();
    final difference = widget.todo.deadline.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Task' : 'Task Details',
          style: AppFonts.spectral(
            color: AppColors.brandText,
            size: 20,
            weight: FontWeight.w300,
          ),
        ),
        actions: [
          if (!isEditing)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.brandText),
              onSelected: (value) {
                if (value == 'edit') {
                  setState(() => isEditing = true);
                } else if (value == 'delete') {
                  _showDeleteDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: isEditing
                  ? CustomTextField(controller: titleController, label: 'Title')
                  : Text(
                      widget.todo.title,
                      style: AppFonts.cardo(
                        color: AppColors.onDark,
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Description Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppFonts.spectral(
                      color: AppColors.brandText,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  isEditing
                      ? Container(
                          height: 120,
                          child: TextField(
                            controller: descriptionController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: 'Description...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.inputBorder,
                                ),
                              ),
                            ),
                            style: AppFonts.cardo(color: AppColors.onDark),
                          ),
                        )
                      : Text(
                          widget.todo.description.isEmpty
                              ? 'No description'
                              : widget.todo.description,
                          style: AppFonts.cardo(
                            color: widget.todo.description.isEmpty
                                ? AppColors.onDark.withOpacity(0.6)
                                : AppColors.onDark,
                            size: 16,
                          ),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Timer Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Time Remaining',
                    style: AppFonts.spectral(
                      color: AppColors.brandText,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatDuration(),
                      style: AppFonts.cardo(
                        color: AppColors.onDark,
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            if (isEditing) ...[
              CustomButton(
                label: 'Save Changes',
                onPressed: _updateTodo,
                loading: loading,
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.surface,
                height: 50,
                textStyle: AppFonts.cardo(
                  color: AppColors.surface,
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Cancel',
                onPressed: () => setState(() => isEditing = false),
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.onDark,
                height: 50,
                textStyle: AppFonts.cardo(
                  color: AppColors.onDark,
                  size: 16,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        title: Text(
          'Really want to delete this task?',
          style: AppFonts.cardo(color: AppColors.brandText, size: 16),
        ),
        actions: [
          CustomButton(
            label: 'Return',
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.onDark,
            width: 100,
            height: 40,
            textStyle: AppFonts.cardo(color: AppColors.onDark, size: 14),
          ),
          const SizedBox(width: 8),
          CustomButton(
            label: 'Delete',
            onPressed: () {
              Navigator.pop(context);
              _deleteTodo();
            },
            backgroundColor: AppColors.brandRed,
            foregroundColor: AppColors.onDark,
            width: 100,
            height: 40,
            textStyle: AppFonts.cardo(color: AppColors.onDark, size: 14),
          ),
        ],
      ),
    );
  }
}
