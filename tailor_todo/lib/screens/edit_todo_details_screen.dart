import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class EditTodoDetailsScreen extends StatefulWidget {
  final Todo todo;
  const EditTodoDetailsScreen({super.key, required this.todo});

  @override
  State<EditTodoDetailsScreen> createState() => _EditTodoDetailsScreenState();
}

class _EditTodoDetailsScreenState extends State<EditTodoDetailsScreen> {
  final supabase = Supabase.instance.client;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTodo() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    setState(() => _loading = true);
    try {
      await supabase
          .from('todos')
          .update({
            'title': _titleController.text.trim(),
            'description': _descriptionController.text.trim(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', widget.todo.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo updated successfully')),
        );
        Navigator.of(context).pop(true); // return to details with refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Task', style: TextStyle(color: AppColors.brandText)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            CustomTextField(controller: _titleController, label: 'Title'),
            const SizedBox(height: 16),

            // Description
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 1.5),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Description...',
                  hintStyle: AppFonts.cardo(
                    color: AppColors.onDark.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: AppFonts.cardo(color: AppColors.onDark),
              ),
            ),
            const SizedBox(height: 28),

            // Save / Cancel
            CustomButton(
              label: 'Save Changes',
              onPressed: _updateTodo,
              loading: _loading,
              height: 48,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
              backgroundColor: AppColors.surface,
              foregroundColor: Colors.white,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
