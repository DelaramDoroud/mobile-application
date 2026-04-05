import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/components/navigation_bar.dart';
import 'package:tourism_app/screens/login.dart';
import 'package:tourism_app/screens/register.dart';
import 'package:tourism_app/theme/app_theme.dart';

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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _animationStarted = true);
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _showActions = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: _GlowCircle(
                size: screenWidth * 0.55,
                color: AppColors.accent.withOpacity(0.18),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: _GlowCircle(
                size: screenWidth * 0.7,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        offset: _animationStarted ? Offset.zero : const Offset(0, 0.08),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 900),
                          opacity: _animationStarted ? 1 : 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 420),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.18),
                                      blurRadius: 24,
                                      offset: const Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(36),
                                  child: AspectRatio(
                                    aspectRatio: 0.96,
                                    child: Image.asset(
                                      'images/pic3.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                'Welcome to easyTrip',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: screenWidth < 380 ? 34 : 40,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 440),
                                child: Text(
                                  'Plan cleaner trips with a calmer palette, faster booking flow, and one place for transport, stays, and tours.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.white.withOpacity(0.86),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      offset: _showActions ? Offset.zero : const Offset(0, 0.15),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        opacity: _showActions ? 1 : 0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionButton(
                                    label: 'Login',
                                    icon: Icons.login_rounded,
                                    filled: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _ActionButton(
                                    label: 'Sign up',
                                    icon: Icons.person_add_alt_1_rounded,
                                    filled: false,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const RegisterPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => NavBar()),
                                );
                              },
                              child: Text(
                                'Skip for now',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = filled ? AppColors.white : Colors.white.withOpacity(0.12);
    final foreground = filled ? AppColors.primary : AppColors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(22),
          border: filled ? null : Border.all(color: Colors.white.withOpacity(0.28)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: foreground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
