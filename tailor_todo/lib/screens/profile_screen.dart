import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
// Assuming this is your header widget file

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header with back button, title, and edit button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.brandText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title box
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Profile',
                        style: AppFonts.spectral(
                          color: AppColors.brandText,
                          size: 20,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Edit button (only show when not editing)
                  if (!isEditing)
                    GestureDetector(
                      onTap: () => setState(() => isEditing = true),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit,
                          color: AppColors.brandText,
                          size: 22,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Profile Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ), // consistent padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Profile picture placeholder
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.onDark,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Name field
                    isEditing
                        ? CustomTextField(
                            controller: nameController,
                            label: 'Name',
                          )
                        : _buildInfoContainer(
                            'Name',
                            nameController.text.isEmpty
                                ? 'Not set'
                                : nameController.text,
                          ),
                    const SizedBox(height: 20),
                    // Email field (always read-only)
                    _buildInfoContainer('Email', emailController.text),
                    const SizedBox(height: 20),
                    // Phone field
                    isEditing
                        ? CustomTextField(
                            controller: phoneController,
                            label: 'Phone number',
                            keyboard: TextInputType.phone,
                          )
                        : _buildInfoContainer(
                            'Phone number',
                            phoneController.text.isEmpty
                                ? 'Not set'
                                : phoneController.text,
                          ),
                    const SizedBox(height: 40),
                    // Action buttons
                    if (isEditing) ...[
                      CustomButton(
                        label: 'Save',
                        onPressed: _updateProfile,
                        loading: loading,
                        height: 50,
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.surface,
                        textStyle: AppFonts.cardo(
                          color: AppColors.surface,
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Cancel',
                        onPressed: () => setState(() => isEditing = false),
                        height: 50,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.onDark,
                        textStyle: AppFonts.cardo(
                          color: AppColors.onDark,
                          size: 18,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ] else ...[
                      // Sign out button
                      CustomButton(
                        label: 'Sign Out',
                        onPressed: _signOut,
                        height: 50,
                        backgroundColor: AppColors.brandRed,
                        foregroundColor: AppColors.onDark,
                        textStyle: AppFonts.cardo(
                          color: AppColors.onDark,
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
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
