import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final String content;
  const ResultScreen({super.key, required this.content});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.content));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  List<_ContentBlock> _parseContent(String raw) {
    final lines = raw.split('\n');
    final blocks = <_ContentBlock>[];
    final buffer = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('## ') || trimmed.startsWith('# ')) {
        if (buffer.isNotEmpty) {
          blocks.add(
            _ContentBlock(
              type: _BlockType.body,
              text: buffer.toString().trim(),
            ),
          );
          buffer.clear();
        }
        blocks.add(
          _ContentBlock(
            type: _BlockType.header,
            text: trimmed
                .replaceAll(RegExp(r'^#+\s*'), '')
                .replaceAll('**', ''),
          ),
        );
      } else if (trimmed.startsWith('**') &&
          trimmed.endsWith('**') &&
          trimmed.length > 4) {
        if (buffer.isNotEmpty) {
          blocks.add(
            _ContentBlock(
              type: _BlockType.body,
              text: buffer.toString().trim(),
            ),
          );
          buffer.clear();
        }
        blocks.add(
          _ContentBlock(
            type: _BlockType.header,
            text: trimmed.replaceAll('**', ''),
          ),
        );
      } else if (trimmed.startsWith('- ') || trimmed.startsWith('• ')) {
        if (buffer.isNotEmpty) {
          blocks.add(
            _ContentBlock(
              type: _BlockType.body,
              text: buffer.toString().trim(),
            ),
          );
          buffer.clear();
        }
        blocks.add(
          _ContentBlock(
            type: _BlockType.bullet,
            text: trimmed.replaceFirst(RegExp(r'^[-•]\s*'), ''),
          ),
        );
      } else {
        buffer.writeln(line);
      }
    }

    if (buffer.isNotEmpty) {
      final remaining = buffer.toString().trim();
      if (remaining.isNotEmpty) {
        blocks.add(_ContentBlock(type: _BlockType.body, text: remaining));
      }
    }
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blocks = _parseContent(widget.content);
    final accent = isDark ? const Color(0xFF7C3AED) : const Color(0xFF5B21B6);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0715)
          : const Color(0xFFF0EEFF),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                // ── Full-width gradient ribbon header ────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: AppTheme.bannerGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          Expanded(
                            child: Text(
                              'Insights',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Copy button
                          GestureDetector(
                            onTap: _copyToClipboard,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: _copied
                                  ? Container(
                                      key: const ValueKey('check'),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Copied',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      key: const ValueKey('copy'),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.copy_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Copy',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // AI badge
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI-Generated Schedule Insights',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Personalized based on your current tasks',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable content ───────────────────────────────────
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    children: blocks
                        .map((b) => _buildBlock(context, b, isDark, accent))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(
    BuildContext context,
    _ContentBlock block,
    bool isDark,
    Color accent,
  ) {
    final cardBg = isDark ? const Color(0xFF160D2A) : const Color(0xFFEDE9FF);

    switch (block.type) {
      case _BlockType.header:
        return Container(
          margin: const EdgeInsets.only(top: 16, bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: accent, width: 4)),
          ),
          child: Text(
            block.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFE9D8FF) : const Color(0xFF1A0833),
              letterSpacing: -0.2,
            ),
          ),
        );

      case _BlockType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7, right: 10),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.primaryGradientDark
                      : AppTheme.primaryGradientLight,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    block.text,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFFAB8FD4)
                          : const Color(0xFF4B2D79),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case _BlockType.body:
        if (block.text.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            block.text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? const Color(0xFFAB8FD4) : const Color(0xFF4B2D79),
              height: 1.65,
            ),
          ),
        );
    }
  }
}

enum _BlockType { header, bullet, body }

class _ContentBlock {
  final _BlockType type;
  final String text;
  const _ContentBlock({required this.type, required this.text});
}
