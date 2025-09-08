import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/fonts.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  Future<void> _loginWithEmail() async {
    setState(() => loading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: emailC.text.trim(),
        password: passC.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signed in')));
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://auth-callback',
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
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
                        size: 40,
                        weight: FontWeight.w300,
                      ),
                    ),
                    spacing,
                    Text(
                      'Login:',
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
                    CustomButton(
                      label: 'Login',
                      onPressed: _loginWithEmail,
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
                    spacing,
                    CustomButton(
                      label: 'Sign In',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.accent,
                      height: 48,
                      textStyle: AppFonts.cardo(
                        color: AppColors.accent,
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                    spacing,
                    CustomButton(
                      label: 'Login With Google',
                      onPressed: _loginWithGoogle,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.surface,
                      height: 48,
                      textStyle: AppFonts.cardo(
                        color: AppColors.surface,
                        size: 16,
                        weight: FontWeight.w500,
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
