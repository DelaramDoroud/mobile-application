import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/click_button.dart';
import '../components/input_fields.dart';
import '../components/navigation_bar.dart';
import '../theme/app_theme.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePwd = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      final username = _usernameCtrl.text.trim();
      await cred.user?.updateDisplayName(username);

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': _emailCtrl.text.trim(),
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => NavBar()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'Email is already in use';
          break;
        case 'invalid-email':
          msg = 'Invalid email';
          break;
        case 'weak-password':
          msg = 'Weak password. Use at least 6 characters';
          break;
        default:
          msg = e.message ?? e.code;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.92),
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
                          'Create account',
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Set up your easyTrip profile once and keep every trip in one consistent place.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        InputFields(
                          controller: _usernameCtrl,
                          hint_text: 'Username',
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
                          controller: _emailCtrl,
                          hint_text: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: BorderRadius.circular(20),
                          hintCoolor: AppColors.muted,
                          fontSize: 16,
                          fillColor: AppColors.surfaceStrong.withOpacity(0.85),
                          borderSide: BorderSide.none,
                          icon: Icons.alternate_email_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is not valid';
                            }
                            final ok = RegExp(
                              r'^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}$',
                            ).hasMatch(v);
                            return ok ? null : 'Email format is not valid';
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
                            if (v.length < 6) {
                              return 'At least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputFields(
                          controller: _confirmCtrl,
                          hint_text: 'Confirm password',
                          borderRadius: BorderRadius.circular(20),
                          hintCoolor: AppColors.muted,
                          fontSize: 16,
                          fillColor: AppColors.surfaceStrong.withOpacity(0.85),
                          borderSide: BorderSide.none,
                          icon: Icons.verified_user_outlined,
                          obscureText: _obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              );
                            },
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password confirm field is empty';
                            }
                            if (v != _passwordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ClickButton(
                          text: 'Sign up',
                          isLoading: _isLoading,
                          onPressed: _onSignUp,
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text('Already have an account? Sign in'),
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
