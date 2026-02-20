import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      duration: const Duration(milliseconds: 600),
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

  // Parse content into sections separated by double newlines or markdown headers
  List<_ContentBlock> _parseContent(String raw) {
    final lines = raw.split('\n');
    final blocks = <_ContentBlock>[];
    final buffer = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();

      // Markdown-style headers (## or **)
      if (trimmed.startsWith('## ') || trimmed.startsWith('# ')) {
        if (buffer.isNotEmpty) {
          blocks.add(_ContentBlock(type: _BlockType.body, text: buffer.toString().trim()));
          buffer.clear();
        }
        blocks.add(_ContentBlock(
          type: _BlockType.header,
          text: trimmed.replaceAll(RegExp(r'^#+\s*'), '').replaceAll('**', ''),
        ));
      } else if (trimmed.startsWith('**') && trimmed.endsWith('**') && trimmed.length > 4) {
        if (buffer.isNotEmpty) {
          blocks.add(_ContentBlock(type: _BlockType.body, text: buffer.toString().trim()));
          buffer.clear();
        }
        blocks.add(_ContentBlock(
          type: _BlockType.header,
          text: trimmed.replaceAll('**', ''),
        ));
      } else if (trimmed.startsWith('- ') || trimmed.startsWith('• ')) {
        if (buffer.isNotEmpty) {
          blocks.add(_ContentBlock(type: _BlockType.body, text: buffer.toString().trim()));
          buffer.clear();
        }
        blocks.add(_ContentBlock(
          type: _BlockType.bullet,
          text: trimmed.replaceFirst(RegExp(r'^[-•]\s*'), ''),
        ));
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final blocks = _parseContent(widget.content);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        title: Text(
          'Insights',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          // Copy button
          GestureDetector(
            onTap: _copyToClipboard,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _copied
                  ? Container(
                      key: const ValueKey('check'),
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Copied',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      key: const ValueKey('copy'),
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            'Copy',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header Banner ─────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI-Generated Schedule',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Personalized insights based on your tasks',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary.withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Parsed Content Blocks ─────────────────────────────────
                ...blocks.map((block) => _buildBlock(context, block)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(BuildContext context, _ContentBlock block) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (block.type) {
      case _BlockType.header:
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 10),
          child: Text(
            block.text,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
        );

      case _BlockType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 10),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  block.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.6,
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
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.75),
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