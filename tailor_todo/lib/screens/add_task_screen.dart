import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

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
      final deadline = DateTime.now().add(duration);

      await supabase.from('todos').insert({
        'user_id': supabase.auth.currentUser!.id,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'deadline': deadline.toIso8601String(),
        'archived': false,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding task: $e')));
    } finally {
      setState(() => loading = false);
    }
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
          'Add Task',
          style: AppFonts.spectral(
            color: AppColors.brandText,
            size: 20,
            weight: FontWeight.w300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            CustomTextField(controller: titleController, label: 'Title....'),
            const SizedBox(height: 20),
            Container(
              height: 200,
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
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.inputBorder,
                      width: 1.5,
                    ),
                  ),
                ),
                style: AppFonts.cardo(color: AppColors.onDark),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Duration',
              style: AppFonts.spectral(color: AppColors.brandText, size: 18),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    style: AppFonts.cardo(color: AppColors.onDark, size: 24),
                  ),
                  _buildTimePicker(
                    'Minutes',
                    minutes,
                    (value) => setState(() => minutes = value),
                  ),
                  Text(
                    ':',
                    style: AppFonts.cardo(color: AppColors.onDark, size: 24),
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
    );
  }

  Widget _buildTimePicker(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showTimePicker(label, value, onChanged),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 4),
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
        title: Text(
          'Select $label',
          style: AppFonts.cardo(color: AppColors.brandText),
        ),
        content: SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: label == 'Hours' ? 24 : 60,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                index.toString().padLeft(2, '0'),
                style: AppFonts.cardo(color: AppColors.onDark),
              ),
              onTap: () {
                onChanged(index);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
