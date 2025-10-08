import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/navigation_bar.dart';
import 'login.dart';
import "../components/input_fields.dart";
import '../components/click_button.dart';

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
    // validating
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      final username = _usernameCtrl.text.trim();
      await cred.user?.updateDisplayName(username);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
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
          msg = 'Email is already in used';
          break;
        case 'invalid-email':
          msg = 'Ivalid Email';
          break;
        case 'weak-password':
          msg = 'Weak Password (at least 6 characters)';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  _header(context),
                  _inputFields(context),
                  _submitButton(context),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text("Already have an account? Sign in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.09,
        //left: MediaQuery.of(context).size.height * 0.1,
      ),
      //width: MediaQuery.of(context).size.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //spacing: 10,
        children: [
          Text(
            "Sign up",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Create your account",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 130, 123, 123),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _inputFields(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputFields(
            controller: _usernameCtrl,
            hint_text: "Username",
            borderRadius: BorderRadius.circular(20),
            hintCoolor: Colors.blueGrey,
            fontSize: 16,
            fillColor: Colors.greenAccent.withOpacity(0.4),
            borderSide: BorderSide.none,
            icon: Icons.person,
            validator:
                (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Username is empty'
                        : null,
          ),
          InputFields(
            controller: _emailCtrl,
            hint_text: "Email",
            keyboardType: TextInputType.emailAddress,
            borderRadius: BorderRadius.circular(20),
            hintCoolor: Colors.blueGrey,
            fontSize: 16,
            fillColor: Colors.greenAccent.withOpacity(0.4),
            borderSide: BorderSide.none,
            icon: Icons.email,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is not valid';
              final ok = RegExp(
                r'^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}$',
              ).hasMatch(v);
              return ok ? null : 'Email format is not valid';
            },
          ),
          InputFields(
            controller: _passwordCtrl,
            hint_text: "Password",
            borderRadius: BorderRadius.circular(20),
            hintCoolor: Colors.blueGrey,
            fontSize: 16,
            fillColor: Colors.greenAccent.withOpacity(0.4),
            borderSide: BorderSide.none,
            icon: Icons.password,
            obscureText: _obscurePwd,
            suffixIcon: IconButton(
              icon: Icon(_obscurePwd ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is empty';
              if (v.length < 6) return 'at least 6 characters';
              return null;
            },
          ),
          InputFields(
            controller: _confirmCtrl,
            hint_text: "Confirm Password",
            borderRadius: BorderRadius.circular(20),
            hintCoolor: Colors.blueGrey,
            fontSize: 16,
            fillColor: Colors.greenAccent.withOpacity(0.4),
            borderSide: BorderSide.none,
            icon: Icons.password,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed:
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            validator: (v) {
              if (v == null || v.isEmpty)
                return 'password confirm field is empty';
              if (v != _passwordCtrl.text)
                return 'password confirm is not equal to password ';
              return null;
            },
          ),
        ],
      ),
    );
  }

  _submitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ClickButton(
          text: "Sign up",
          isLoading: _isLoading,
          onPressed: _onSignUp,
          backgroundColor: Colors.greenAccent,
        ),
      ),
    );
  }
}
