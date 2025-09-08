import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../notifications/notification_service.dart'; // Import notification service

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final supabase = Supabase.instance.client;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool loading = false;

  Future<void> _addTask() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }
    setState(() => loading = true);
    try {
      final duration = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );
      final deadline = DateTime.now().toUtc().add(duration);

      // Insert new task and get inserted ID
      final inserted = await supabase
          .from('todos')
          .insert({
            'user_id': supabase.auth.currentUser!.id,
            'title': titleController.text.trim(),
            'description': descriptionController.text.trim(),
            'deadline': deadline.toIso8601String(),
            'archived': false,
          })
          .select('id')
          .single();

      // --- KEY ADDITION: Schedule local notification ---
      final String todoId = inserted['id'].toString();

      await NotificationService.instance.scheduleDeadline(
        todoId: todoId,
        title: titleController.text.trim(),
        deadlineUtc: deadline,
      );
      // --- END KEY ADDITION ---

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding task: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.brandText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Add Task',
                          style: AppFonts.spectral(
                            color: AppColors.brandText,
                            size: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: titleController,
                      label: 'Title....',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: descriptionController,
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
                    const SizedBox(height: 24),
                    Text(
                      'Duration',
                      style: AppFonts.spectral(
                        color: AppColors.brandText,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimePicker(
                            'Hours',
                            hours,
                            (value) => setState(() => hours = value),
                          ),
                          Text(
                            ':',
                            style: AppFonts.cardo(
                              color: AppColors.onDark,
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          _buildTimePicker(
                            'Minutes',
                            minutes,
                            (value) => setState(() => minutes = value),
                          ),
                          Text(
                            ':',
                            style: AppFonts.cardo(
                              color: AppColors.onDark,
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          _buildTimePicker(
                            'Seconds',
                            seconds,
                            (value) => setState(() => seconds = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      label: 'Done',
                      onPressed: _addTask,
                      loading: loading,
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.surface,
                      height: 50,
                      textStyle: AppFonts.cardo(
                        color: AppColors.surface,
                        size: 18,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, int value, Function(int) onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showTimePicker(label, value, onChanged),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: AppFonts.cardo(
                    color: AppColors.onDark,
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.cardo(color: AppColors.brandText, size: 12),
        ),
      ],
    );
  }

  void _showTimePicker(
    String label,
    int currentValue,
    Function(int) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        title: Text(
          'Select $label',
          style: AppFonts.cardo(
            color: AppColors.brandText,
            size: 18,
            weight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          height: 200,
          width: 150,
          child: ListView.builder(
            itemCount: label == 'Hours' ? 24 : 60,
            itemBuilder: (context, index) => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onChanged(index);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: AppFonts.cardo(
                        color: currentValue == index
                            ? AppColors.accent
                            : AppColors.onDark,
                        size: 16,
                        weight: currentValue == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppFonts.cardo(color: AppColors.brandText),
            ),
          ),
        ],
      ),
    );
  }
}
