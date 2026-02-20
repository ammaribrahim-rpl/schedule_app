import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String message = '';
  bool _obscure = true;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await cred.user!.updateDisplayName(_usernameController.text.trim());
      await cred.user!.reload();

      setState(() {
        message = 'Account created for ${_usernameController.text.trim()} 🎉';
        _isLoading = false;
      });
      _emailController.clear();
      _passwordController.clear();
      _usernameController.clear();
    } catch (e) {
      setState(() {
        message = 'Registration failed. Please try again.';
        _isLoading = false;
      });
    }
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
                // ── Compact gradient header ──────────────────────────────
                _RegisterHeader(onBack: () => Navigator.pop(context)),

                // ── Form scrollable area ─────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create account',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: isDark
                                ? const Color(0xFFE9D8FF)
                                : const Color(0xFF1A0833),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set up your profile to get started.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFFAB8FD4)
                                : const Color(0xFF7B5EB0),
                          ),
                        ),

                        const SizedBox(height: 28),

                        if (message.isNotEmpty) ...[
                          AuthStatusBanner(
                            message: message,
                            isSuccess: message.contains('created'),
                          ),
                          const SizedBox(height: 20),
                        ],

                        const AuthFieldLabel('Username'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _usernameController,
                          hint: 'Choose a display name',
                          isDark: isDark,
                        ),

                        const SizedBox(height: 18),

                        const AuthFieldLabel('Email'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _emailController,
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 18),

                        const AuthFieldLabel('Password'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _passwordController,
                          hint: 'Min. 8 characters',
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

                        AuthGradientButton(
                          label: 'Create Account',
                          isLoading: _isLoading,
                          onTap: _isLoading ? null : _register,
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFAB8FD4)
                                          : const Color(0xFF7B5EB0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign In',
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
// REGISTER HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _RegisterHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _RegisterHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppTheme.bannerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Step indicator dots
          Row(
            children: List.generate(3, (i) {
              final isActive = i == 0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          Text(
            'Step 1 of 3',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
