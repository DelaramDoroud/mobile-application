import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/navigation_bar.dart';
import 'register.dart';
import '../components/input_fields.dart';
import '../components/click_button.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
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
            "Sign in",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "to your account",
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
            controller: _emailCtrl,
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
            validator:
                (v) => (v == null || v.isEmpty) ? 'Password is empty' : null,
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
          text: "Log in",
          isLoading: _isLoading,
          onPressed: _onSignIn,
          backgroundColor: Colors.greenAccent,
        ),
      ),
    );
  }
}
