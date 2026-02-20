import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: isDark
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF5B21B6),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: isDark
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF5B21B6),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      Provider.of<ScheduleProvider>(
        context,
        listen: false,
      ).addTask(_titleController.text, dateTime);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0715) : const Color(0xFFF0EEFF),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.bannerGradient,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Row(
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
                                Icons.close_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'New Task',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Form ─────────────────────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel('Task Details', isDark: isDark),
                            const SizedBox(height: 12),

                            // Task title field
                            TextFormField(
                              controller: _titleController,
                              autofocus: true,
                              maxLines: 3,
                              minLines: 2,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isDark
                                    ? const Color(0xFFE9D8FF)
                                    : const Color(0xFF1A0833),
                              ),
                              decoration: InputDecoration(
                                hintText: 'What needs to be done?',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: isDark
                                      ? const Color(0xFF7B5EB0)
                                      : const Color(0xFFAB8FD4),
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Please enter a task title'
                                  : null,
                            ),

                            const SizedBox(height: 28),

                            _SectionLabel('Schedule', isDark: isDark),
                            const SizedBox(height: 12),

                            // Side-by-side date + time pickers
                            Row(
                              children: [
                                Expanded(
                                  child: _PickerCard(
                                    onTap: _pickDate,
                                    icon: Icons.calendar_month_rounded,
                                    label: 'Date',
                                    value: DateFormat(
                                      'MMM d, EEE',
                                    ).format(_selectedDate),
                                    isDark: isDark,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _PickerCard(
                                    onTap: _pickTime,
                                    icon: Icons.access_time_rounded,
                                    label: 'Time',
                                    value: _selectedTime.format(context),
                                    isDark: isDark,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 36),

                            // Save button
                            _GradientSaveButton(onTap: _saveTask),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? const Color(0xFF7B5EB0) : const Color(0xFFAB8FD4),
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _PickerCard({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6);
    final cardBg = isDark ? const Color(0xFF160D2A) : const Color(0xFFEDE9FF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppTheme.primaryGradientDark
                    : AppTheme.primaryGradientLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFE9D8FF)
                    : const Color(0xFF1A0833),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientSaveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GradientSaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
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
                  (isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6))
                      .withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Save Task',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
