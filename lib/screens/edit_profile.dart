import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/input_fields.dart';
import 'login.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _pwdFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _currentPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();
  bool _isLoading = false;
  // bool _showPwdFields = false;
  bool _obscCur = true, _obscNew = true, _obscCnf = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameCtrl.text = user?.displayName ?? "";
  }

  @override
  void dispose() {
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

      final username = _usernameCtrl.text.trim();

      // Auth displayName
      await user.updateDisplayName(username);

      // Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Update failed')));
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
          (e.code == 'wrong-password')
              ? 'Current password is incorrect'
              : e.message ?? 'Password update failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.15,
            horizontal: 20,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Form(
                key: _profileFormKey, // ✅ فرم پروفایل
                child: InputFields(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  hintCoolor: Colors.blueGrey,
                  fontSize: 16,
                  borderSide: BorderSide.none,
                  icon: Icons.person,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? "Username required"
                              : null,
                ),
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.arrow_circle_down_sharp,
                  color: Color.fromARGB(255, 57, 150, 105),
                ),
                title: const Text(
                  "Change password",
                  style: TextStyle(
                    color: Color.fromARGB(255, 57, 150, 105),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap:
                    () => showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text("Change Password"),
                            content: _input_fields(ctx),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Cancel"),
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
                                        : const Text("Save"),
                              ),
                            ],
                          ),
                    ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 100, 233, 202),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save changes"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _logout,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text("Log out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _input_fields(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Form(
      key: _pwdFormKey,
      child: Container(
        height: screenHeight * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InputFields(
              controller: _currentPwdCtrl,
              decoration: const InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
                          ? "Enter current password"
                          : null,
            ),
            InputFields(
              controller: _newPwdCtrl,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              borderRadius: BorderRadius.circular(10),
              hintCoolor: Colors.blueGrey,
              fontSize: 16,
              borderSide: BorderSide.none,
              suffixIcon: IconButton(
                icon: Icon(_obscNew ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscNew = !_obscNew),
              ),

              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Enter new password";
                }
                if (v.length < 6) {
                  return "At least 6 characters";
                }
                if (v == _currentPwdCtrl.text.trim()) {
                  return "New password must differ";
                }
                return null;
              },
            ),
            InputFields(
              controller: _confirmPwdCtrl,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
                      (v != _newPwdCtrl.text.trim())
                          ? "Passwords do not match"
                          : null,
            ),
          ],
        ),
      ),
    );
  }
}
