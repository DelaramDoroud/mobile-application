import 'package:flutter/material.dart';
// import 'package:tourism_app/screens/home.dart';
import 'package:tourism_app/screens/login.dart';
import 'package:tourism_app/screens/register.dart';
import 'package:tourism_app/components/navigation_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _animationStarted = false;
  bool _showActions = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _animationStarted = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _showActions = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(168, 67, 188, 130),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: screenHeight * 0.3,
            left: _animationStarted ? screenWidth * 0.1 : screenWidth * 0.4,
            width: _animationStarted ? screenWidth * 0.8 : screenWidth * 0.2,
            height: _animationStarted ? screenWidth : screenWidth * 0.6,
            child: Column(
              spacing: 20,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset("images/pic3.jpg"),
                ),
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize:
                        _animationStarted
                            ? screenWidth * 0.05
                            : screenWidth * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: Duration(seconds: 2),
                  child: Text("Wlcome to easy trip"),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            curve: Curves.easeOut,
            top: _showActions ? screenHeight * 0.62 : screenHeight * 0.68,
            left: screenWidth * 0.10,
            right: screenWidth * 0.10,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              opacity: _showActions ? 1.0 : 0.0,
              child: Column(
                children: [
                  Row(
                    spacing: screenWidth * 0.05,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(2, (index) {
                        return Expanded(
                          child: _BubbleButton(
                            label: index == 0 ? "Login" : "Sign up",
                            icon:
                                index == 0
                                    ? Icons.login_rounded
                                    : Icons.person_add_alt_1_rounded,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          index == 0
                                              ? const LoginPage()
                                              : const RegisterPage(),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => NavBar()),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.90),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        //decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BubbleButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.035,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1F6F5C)),
            SizedBox(width: w * 0.02),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1F6F5C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
