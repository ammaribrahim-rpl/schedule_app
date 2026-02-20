import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'there';
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0B0715) : const Color(0xFFF0EEFF);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Inline greeting header ───────────────────────────────────
            _GreetingHeader(
              greeting: _greeting(),
              name: _firstName(),
              tabLabel: _selectedIndex == 0 ? 'My Tasks' : 'History',
              isDark: isDark,
            ),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: _selectedIndex == 0
                  ? const TaskListTab()
                  : const HistoryTab(),
            ),
          ],
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButton: _selectedIndex == 0
          ? _GradientFAB(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ── Floating pill nav ────────────────────────────────────────────────
      bottomNavigationBar: _FloatingPillNav(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped,
        isDark: isDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GREETING HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final String tabLabel;
  final bool isDark;

  const _GreetingHeader({
    required this.greeting,
    required this.name,
    required this.tabLabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: const BoxDecoration(
        gradient: AppTheme.bannerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $name 👋',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 14),
          // Sub-label chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              tabLabel,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FLOATING PILL NAV
// ─────────────────────────────────────────────────────────────────────────────

class _FloatingPillNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _FloatingPillNav({
    required this.selectedIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.check_circle_outline_rounded, Icons.check_circle_rounded, 'Tasks'),
      (Icons.history_outlined, Icons.history_rounded, 'History'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF160D2A) : const Color(0xFFE4DAFF),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color:
                  (isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6))
                      .withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (i) {
            final isSelected = i == selectedIndex;
            final (outlineIcon, filledIcon, label) = items[i];
            final accentColor = isDark
                ? const Color(0xFF7C3AED)
                : const Color(0xFF5B21B6);
            final dimColor = isDark
                ? const Color(0xFF5B3A8C)
                : const Color(0xFFAB8FD4);

            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: isSelected
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: isSelected
                    ? BoxDecoration(
                        gradient: isDark
                            ? AppTheme.primaryGradientDark
                            : AppTheme.primaryGradientLight,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      )
                    : null,
                child: Row(
                  children: [
                    Icon(
                      isSelected ? filledIcon : outlineIcon,
                      size: 20,
                      color: isSelected ? Colors.white : dimColor,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENT FAB
// ─────────────────────────────────────────────────────────────────────────────

class _GradientFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _GradientFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(bottom: 72),
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.primaryGradientDark
              : AppTheme.primaryGradientLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  (isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6))
                      .withOpacity(0.5),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TASK LIST TAB
// ─────────────────────────────────────────────────────────────────────────────

class TaskListTab extends StatelessWidget {
  const TaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<ScheduleProvider>(context);
    final tasks = provider.tasks;

    return Column(
      children: [
        Expanded(
          child: tasks.isEmpty
              ? _EmptyState(
                  icon: Icons.checklist_rounded,
                  title: 'No tasks yet',
                  subtitle: 'Tap + to add your first task',
                  isDark: isDark,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _TaskCard(
                      title: task.title,
                      dateTime: task.dateTime,
                      onDismiss: () {
                        provider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Task removed',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        );
                      },
                      dismissKey: Key(task.id),
                      isDark: isDark,
                    );
                  },
                ),
        ),

        // ── Generate Insights CTA ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: GestureDetector(
            onTap: (tasks.isEmpty || provider.isLoading)
                ? null
                : () async {
                    await provider.generateScheduleInsights();
                    if (context.mounted && provider.generatedContent != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ResultScreen(content: provider.generatedContent!),
                        ),
                      );
                    }
                  },
            child: AnimatedOpacity(
              opacity: (tasks.isEmpty || provider.isLoading) ? 0.45 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.primaryGradientDark
                      : AppTheme.primaryGradientLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isDark
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFF5B21B6))
                              .withOpacity(tasks.isEmpty ? 0 : 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: provider.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Generating…',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Generate Insights',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HISTORY TAB
// ─────────────────────────────────────────────────────────────────────────────

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<ScheduleProvider>(context);
    final history = provider.history;

    if (history.isEmpty) {
      return _EmptyState(
        icon: Icons.history_rounded,
        title: 'No history yet',
        subtitle: 'Generated insights will appear here',
        isDark: isDark,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final preview = item.content.replaceAll('\n', ' ');
        final cardBg = isDark
            ? const Color(0xFF160D2A)
            : const Color(0xFFEDE9FF);
        final accent = isDark
            ? const Color(0xFF7C3AED)
            : const Color(0xFF5B21B6);

        return Dismissible(
          key: Key(item.id),
          onDismissed: (_) {
            provider.deleteHistory(item.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'History removed',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            );
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7F1D1D), Color(0xFFB91C1C)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(content: item.content),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withOpacity(0.15), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppTheme.primaryGradientDark
                          : AppTheme.primaryGradientLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'MMM d, yyyy · HH:mm',
                          ).format(item.timestamp),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accent.withOpacity(0.7),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          preview.length > 58
                              ? '${preview.substring(0, 58)}…'
                              : preview,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFAB8FD4)
                                : const Color(0xFF4B2D79),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF5B3A8C)
                        : const Color(0xFFAB8FD4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TASK CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final VoidCallback onDismiss;
  final Key dismissKey;
  final bool isDark;

  const _TaskCard({
    required this.title,
    required this.dateTime,
    required this.onDismiss,
    required this.dismissKey,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(dateTime, DateTime.now());
    final isPast = dateTime.isBefore(DateTime.now());
    final accent = isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6);
    final cardBg = isDark ? const Color(0xFF160D2A) : const Color(0xFFEDE9FF);

    return Dismissible(
      key: dismissKey,
      onDismissed: (_) => onDismiss(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isToday
                ? accent.withOpacity(0.45)
                : accent.withOpacity(0.12),
            width: isToday ? 1.5 : 1,
          ),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                height: 46,
                decoration: BoxDecoration(
                  gradient: isPast
                      ? null
                      : (isDark
                            ? AppTheme.primaryGradientDark
                            : AppTheme.primaryGradientLight),
                  color: isPast
                      ? (isDark
                            ? const Color(0xFF2D1A4F)
                            : const Color(0xFFD6C4F0))
                      : null,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPast
                            ? (isDark
                                  ? const Color(0xFF5B3A8C)
                                  : const Color(0xFFAB8FD4))
                            : (isDark
                                  ? const Color(0xFFE9D8FF)
                                  : const Color(0xFF1A0833)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: isDark
                              ? const Color(0xFF5B3A8C)
                              : const Color(0xFFAB8FD4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('EEE, MMM d · HH:mm').format(dateTime),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF5B3A8C)
                                : const Color(0xFFAB8FD4),
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? AppTheme.primaryGradientDark
                                  : AppTheme.primaryGradientLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Today',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppTheme.primaryGradientDark
                  : AppTheme.primaryGradientLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      (isDark
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF5B21B6))
                          .withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFAB8FD4) : const Color(0xFF7B5EB0),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? const Color(0xFF5B3A8C) : const Color(0xFFAB8FD4),
            ),
          ),
        ],
      ),
    );
  }
}
