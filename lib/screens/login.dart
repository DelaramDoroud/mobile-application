import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/click_button.dart';
import '../components/input_fields.dart';
import '../components/navigation_bar.dart';
import '../theme/app_theme.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePwd = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => NavBar()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign in',
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Access your bookings and continue planning your next trip.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        InputFields(
                          controller: _emailCtrl,
                          hint_text: 'Email or username',
                          borderRadius: BorderRadius.circular(20),
                          hintCoolor: AppColors.muted,
                          fontSize: 16,
                          fillColor: AppColors.surfaceStrong.withOpacity(0.85),
                          borderSide: BorderSide.none,
                          icon: Icons.person_outline_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Username is empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputFields(
                          controller: _passwordCtrl,
                          hint_text: 'Password',
                          borderRadius: BorderRadius.circular(20),
                          hintCoolor: AppColors.muted,
                          fontSize: 16,
                          fillColor: AppColors.surfaceStrong.withOpacity(0.85),
                          borderSide: BorderSide.none,
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePwd,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePwd
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscurePwd = !_obscurePwd);
                            },
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ClickButton(
                          text: 'Log in',
                          isLoading: _isLoading,
                          onPressed: _onSignIn,
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text("Don't have an account? Sign up"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
