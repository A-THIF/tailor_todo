import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/todo.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/todo_details_action.dart';
import '../widgets/confirmation_dialog.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Todo todo;

  const TodoDetailsScreen({super.key, required this.todo});

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  final supabase = Supabase.instance.client;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  bool _isEditing = false;
  bool _loading = false;

  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    _startTimer();
  }

  void _startTimer() {
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now().toUtc();
    final diff = widget.todo.deadline.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo updated successfully')),
      );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }

    setState(() => _loading = false);
  }

  Future<void> _deleteTodo() async {
    try {
      await supabase.from('todos').delete().eq('id', widget.todo.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Todo deleted')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Really want to delete this task?',
        onConfirm: _deleteTodo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Task' : 'Task Details',
          style: TextStyle(color: AppColors.brandText),
        ),
        actions: [
          if (!_isEditing)
            TodoDetailsActions(
              onEdit: () => setState(() => _isEditing = true),
              onDelete: _showDeleteDialog,
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _isEditing
                  ? TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: AppColors.brandText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: AppColors.primary,
                      ),
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      widget.todo.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 1.5),
              ),
              child: _isEditing
                  ? TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: AppColors.brandText),
                      ),
                      style: const TextStyle(color: Colors.white),
                    )
                  : Text(
                      widget.todo.description.isNotEmpty
                          ? widget.todo.description
                          : 'No description',
                      style: TextStyle(color: AppColors.brandText),
                    ),
            ),
            const SizedBox(height: 20),

            // Remaining Time
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
                    style: TextStyle(color: AppColors.brandText, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatDuration(_remaining),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Buttons for save/cancel in edit mode
            if (_isEditing) ...[
              CustomButton(
                label: 'Save Changes',
                onPressed: _updateTodo,
                loading: _loading,
                height: 48,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Cancel',
                onPressed: () => setState(() => _isEditing = false),
                backgroundColor: AppColors.surface,
                foregroundColor: Colors.white,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
