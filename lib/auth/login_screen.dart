import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home_screen.dart';
import '../theme/app_theme.dart';
import 'auth_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String message = '';
  bool _obscure = true;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        message = 'Login Successful';
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pushReplacement(context, _fadeRoute(const HomeScreen()));
      }
    } catch (e) {
      setState(() {
        message = 'Incorrect email or password.';
        _isLoading = false;
      });
    }
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0715)
          : const Color(0xFFF0EEFF),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: SafeArea(
            child: Column(
              children: [
                // ── Top gradient banner ──────────────────────────────────
                _TopBanner(),

                // ── Form card ────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: isDark
                                ? const Color(0xFFE9D8FF)
                                : const Color(0xFF1A0833),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to manage your schedule.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFFAB8FD4)
                                : const Color(0xFF7B5EB0),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Error / status chip
                        if (message.isNotEmpty) ...[
                          AuthStatusBanner(
                            message: message,
                            isSuccess: message.contains('Successful'),
                          ),
                          const SizedBox(height: 20),
                        ],

                        AuthFieldLabel('Email'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _emailController,
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 20),

                        AuthFieldLabel('Password'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _passwordController,
                          hint: '••••••••',
                          obscure: _obscure,
                          isDark: isDark,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: isDark
                                  ? const Color(0xFF7B5EB0)
                                  : const Color(0xFFAB8FD4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Gradient Sign In button ──────────────────────
                        AuthGradientButton(
                          label: 'Sign In',
                          isLoading: _isLoading,
                          onTap: _isLoading ? null : _login,
                        ),

                        const SizedBox(height: 28),

                        // ── Register link ────────────────────────────────
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFAB8FD4)
                                          : const Color(0xFF7B5EB0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFA78BFA)
                                          : const Color(0xFF5B21B6),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: isDark ? const Color(0xFFE9D8FF) : const Color(0xFF1A0833),
      ),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffix != null
            ? Padding(padding: const EdgeInsets.only(right: 14), child: suffix)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP GRADIENT BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _TopBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
      decoration: const BoxDecoration(
        gradient: AppTheme.bannerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo mark
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Planify',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your AI-powered schedule assistant',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }
}
