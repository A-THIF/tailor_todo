import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isEditing = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _loadUserProfile() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
      nameController.text = user.userMetadata?['name'] ?? '';
      phoneController.text = user.userMetadata?['phone'] ?? '';
    }
  }

  Future<void> _updateProfile() async {
    setState(() => loading = true);

    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
          },
        ),
      );

      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
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
          'Profile',
          style: AppFonts.spectral(
            color: AppColors.brandText,
            size: 20,
            weight: FontWeight.w300,
          ),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.brandText),
              onPressed: () => setState(() => isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.onDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 60, color: AppColors.surface),
              ),
            ),

            const SizedBox(height: 32),

            // Name Field
            isEditing
                ? CustomTextField(controller: nameController, label: 'Name')
                : _buildInfoContainer(
                    'Name',
                    nameController.text.isEmpty
                        ? 'Not set'
                        : nameController.text,
                  ),

            const SizedBox(height: 20),

            // Email Field (read-only)
            _buildInfoContainer('Email', emailController.text),

            const SizedBox(height: 20),

            // Phone Field
            isEditing
                ? CustomTextField(
                    controller: phoneController,
                    label: 'Phone no.',
                    keyboard: TextInputType.phone,
                  )
                : _buildInfoContainer(
                    'Phone no.',
                    phoneController.text.isEmpty
                        ? 'Not set'
                        : phoneController.text,
                  ),

            const SizedBox(height: 40),

            // Action Buttons
            if (isEditing) ...[
              CustomButton(
                label: 'Done',
                onPressed: _updateProfile,
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
                label: 'Back',
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
            ] else ...[
              CustomButton(
                label: 'Sign Out',
                onPressed: _signOut,
                backgroundColor: AppColors.brandRed,
                foregroundColor: AppColors.onDark,
                height: 50,
                textStyle: AppFonts.cardo(
                  color: AppColors.onDark,
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
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
            label,
            style: AppFonts.spectral(color: AppColors.brandText, size: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.cardo(
              color: value == 'Not set'
                  ? AppColors.onDark.withOpacity(0.6)
                  : AppColors.onDark,
              size: 16,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
