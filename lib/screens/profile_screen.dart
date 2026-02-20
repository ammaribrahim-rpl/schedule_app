import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import '../auth/login_screen.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<ScheduleProvider>(context);

    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'User';
    final initial = displayName.substring(0, 1).toUpperCase();

    final taskCount = provider.tasks.length;
    final historyCount = provider.history.length;
    final isDarkMode = provider.themeMode == ThemeMode.dark;

    final accent = isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6);
    final cardBg = isDark ? const Color(0xFF160D2A) : const Color(0xFFEDE9FF);
    final dividerColor = isDark
        ? const Color(0xFF2D1A4F)
        : const Color(0xFFD6C4F0);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0715)
          : const Color(0xFFF0EEFF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Gradient hero area ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: const BoxDecoration(
                gradient: AppTheme.bannerGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Back button row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Circular gradient ring avatar
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user?.email ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stat row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(value: taskCount.toString(), label: 'Tasks'),
                      Container(
                        width: 1,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _StatChip(
                        value: historyCount.toString(),
                        label: 'Insights',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable content ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeading('PREFERENCES', isDark: isDark),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accent.withOpacity(0.15)),
                      ),
                      child: _SettingsTile(
                        icon: isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        label: 'Appearance',
                        value: isDarkMode ? 'Dark Mode' : 'Light Mode',
                        isDark: isDark,
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (v) => provider.toggleTheme(v),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    _SectionHeading('ACCOUNT', isDark: isDark),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accent.withOpacity(0.15)),
                      ),
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Display Name',
                            value: displayName,
                            isDark: isDark,
                            showDivider: true,
                            dividerColor: dividerColor,
                          ),
                          _SettingsTile(
                            icon: Icons.mail_outline_rounded,
                            label: 'Email',
                            value: user?.email ?? '—',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Logout button
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? const Color(0xFF7B5EB0) : const Color(0xFFAB8FD4),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool showDivider;
  final Color? dividerColor;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.trailing,
    this.showDivider = false,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.primaryGradientDark
                      : AppTheme.primaryGradientLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFE9D8FF)
                            : const Color(0xFF1A0833),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            endIndent: 16,
            color: dividerColor,
          ),
      ],
    );
  }
}
