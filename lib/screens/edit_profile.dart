import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/click_button.dart';
import '../components/input_fields.dart';
import 'landing.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _pwdFormKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _currentPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscCur = true;
  bool _obscNew = true;
  bool _obscCnf = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = snapshot.data() ?? {};

    if (!mounted) return;
    _nameCtrl.text = data['name']?.toString() ?? '';
    _surnameCtrl.text = data['surname']?.toString() ?? '';
    _usernameCtrl.text = data['username']?.toString() ?? user.displayName ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _usernameCtrl.dispose();
    _currentPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!(_profileFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final name = _nameCtrl.text.trim();
      final surname = _surnameCtrl.text.trim();
      final username = _usernameCtrl.text.trim();

      await user.updateDisplayName(username);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'surname': surname,
        'username': username,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Update failed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    if (!(_pwdFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;
      if (user == null || email == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'No user session',
        );
      }

      final cred = EmailAuthProvider.credential(
        email: email,
        password: _currentPwdCtrl.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPwdCtrl.text.trim());

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );

      _currentPwdCtrl.clear();
      _newPwdCtrl.clear();
      _confirmPwdCtrl.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg =
          e.code == 'wrong-password'
              ? 'Current password is incorrect'
              : e.message ?? 'Password update failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.08,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Form(
                key: _profileFormKey,
                child: Column(
                  children: [
                    InputFields(
                      controller: _nameCtrl,
                      hint_text: 'Name',
                      borderRadius: BorderRadius.circular(10),
                      hintCoolor: Colors.blueGrey,
                      fontSize: 16,
                      borderSide: BorderSide.none,
                      icon: Icons.badge_outlined,
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Name required'
                                  : null,
                    ),
                    const SizedBox(height: 15),
                    InputFields(
                      controller: _surnameCtrl,
                      hint_text: 'Surname',
                      borderRadius: BorderRadius.circular(10),
                      hintCoolor: Colors.blueGrey,
                      fontSize: 16,
                      borderSide: BorderSide.none,
                      icon: Icons.contacts_outlined,
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Surname required'
                                  : null,
                    ),
                    const SizedBox(height: 15),
                    InputFields(
                      controller: _usernameCtrl,
                      hint_text: 'Username',
                      borderRadius: BorderRadius.circular(10),
                      hintCoolor: Colors.blueGrey,
                      fontSize: 16,
                      borderSide: BorderSide.none,
                      icon: Icons.alternate_email_rounded,
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Username required'
                                  : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.arrow_circle_down_sharp,
                  color: Color.fromARGB(255, 57, 150, 105),
                ),
                title: const Text(
                  'Change password',
                  style: TextStyle(
                    color: Color.fromARGB(255, 57, 150, 105),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Change Password'),
                          content: _passwordFields(ctx),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  100,
                                  233,
                                  202,
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text('Save'),
                            ),
                          ],
                        ),
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ClickButton(
                  text: 'Save changes',
                  isLoading: _isLoading,
                  onPressed: _saveChanges,
                  backgroundColor: const Color.fromARGB(255, 100, 233, 202),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _logout,
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  child: const Text('Log out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordFields(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _pwdFormKey,
      child: SizedBox(
        height: screenHeight * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InputFields(
              controller: _currentPwdCtrl,
              hint_text: 'Current Password',
              obscureText: _obscCur,
              borderRadius: BorderRadius.circular(10),
              hintCoolor: Colors.blueGrey,
              fontSize: 16,
              borderSide: BorderSide.none,
              suffixIcon: IconButton(
                icon: Icon(_obscCur ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscCur = !_obscCur),
              ),
              validator:
                  (v) =>
                      (v == null || v.isEmpty)
                          ? 'Enter current password'
                          : null,
            ),
            InputFields(
              controller: _newPwdCtrl,
              hint_text: 'New Password',
              obscureText: _obscNew,
              borderRadius: BorderRadius.circular(10),
              hintCoolor: Colors.blueGrey,
              fontSize: 16,
              borderSide: BorderSide.none,
              suffixIcon: IconButton(
                icon: Icon(_obscNew ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscNew = !_obscNew),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter new password';
                if (v.length < 6) return 'At least 6 characters';
                if (v == _currentPwdCtrl.text.trim()) {
                  return 'New password must differ';
                }
                return null;
              },
            ),
            InputFields(
              controller: _confirmPwdCtrl,
              hint_text: 'Confirm Password',
              obscureText: _obscCnf,
              borderRadius: BorderRadius.circular(10),
              hintCoolor: Colors.blueGrey,
              fontSize: 16,
              borderSide: BorderSide.none,
              suffixIcon: IconButton(
                icon: Icon(_obscCnf ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscCnf = !_obscCnf),
              ),
              validator:
                  (v) =>
                      v != _newPwdCtrl.text.trim()
                          ? 'Passwords do not match'
                          : null,
            ),
          ],
        ),
      ),
    );
  }
}
