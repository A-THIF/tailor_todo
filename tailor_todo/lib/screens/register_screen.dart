import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/fonts.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

final supabase = Supabase.instance.client;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();
  bool loading = false;

  Future<void> _register() async {
    if (passC.text != confirmC.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => loading = true);
    try {
      await supabase.auth.signUp(
        email: emailC.text.trim(),
        password: passC.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check email to verify your account')),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 18);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    spacing,
                    Text(
                      'Tailor Apps',
                      textAlign: TextAlign.center,
                      style: AppFonts.spectral(
                        color: AppColors.brandText,
                        size: 32,
                        weight: FontWeight.w300,
                      ),
                    ),
                    spacing,
                    Text(
                      'Sign In:',
                      textAlign: TextAlign.center,
                      style: AppFonts.spectral(
                        color: AppColors.brandText,
                        size: 24,
                        weight: FontWeight.w300,
                      ),
                    ),
                    spacing,
                    CustomTextField(
                      controller: emailC,
                      label: 'E-mail',
                      keyboard: TextInputType.emailAddress,
                    ),
                    spacing,
                    CustomTextField(
                      controller: passC,
                      label: 'Password',
                      obscure: true,
                    ),
                    spacing,
                    CustomTextField(
                      controller: confirmC,
                      label: 'Re-enter Password',
                      obscure: true,
                    ),
                    spacing,
                    CustomButton(
                      label: 'Sign In',
                      onPressed: _register,
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
          ),
        ),
      ),
    );
  }
}
