part of 'agenda_controller.dart';

class _AgendaView extends GetView<AgendaController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar Area for Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: _buildSearchBar(theme, isDark),
            ),
          ),
          
          Obx(() {
            final grouped = controller.groupedAgendas;
            if (controller.agendas.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(theme, isDark),
              );
            }
            
            if (grouped.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _buildNoResultsState(theme, isDark),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, groupIndex) {
                  final dateKey = grouped.keys.elementAt(groupIndex);
                  final items = grouped[dateKey]!;
                  final date = DateTime.parse(dateKey);
                  final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == dateKey;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Row(
                          children: [
                            Text(
                              isToday ? 'Today' : DateFormat('EEEE, dd MMM').format(date),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Divider(color: theme.dividerColor.withValues(alpha: 0.1))),
                          ],
                        ),
                      ),
                      ...items.map((agenda) {
                        final isUpcoming = controller.isUpcoming(agenda['dateTime']);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Dismissible(
                            key: Key(agenda['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                              child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                            ),
                            confirmDismiss: (direction) async {
                              controller.deleteAgenda(agenda['id']);
                              return false;
                            },
                            child: _AgendaCard(
                              agenda: agenda,
                              isUpcoming: isUpcoming,
                              isDark: isDark,
                              onTap: () => controller.showEditAgendaSheet(context, agenda),
                              onDelete: () => controller.deleteAgenda(agenda['id']),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
                childCount: grouped.length,
              ),
            );
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showAddAgendaSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Agenda'),
        elevation: 4,
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search agendas...',
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildNoResultsState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No matching agendas',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search query',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_rounded, size: 100, color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'No Agendas Yet',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first agenda',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final Map<String, dynamic> agenda;
  final bool isUpcoming;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AgendaCard({
    required this.agenda,
    required this.isUpcoming,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgendaController>();
    Theme.of(context);

    final gradientColors = isUpcoming
        ? [
            isDark ? const Color(0xFF1E3A5F) : const Color(0xFF4A90D9),
            isDark ? const Color(0xFF2D5A87) : const Color(0xFF67A8E5),
          ]
        : [isDark ? Colors.grey.shade800 : Colors.grey.shade400, isDark ? Colors.grey.shade700 : Colors.grey.shade300];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: isUpcoming ? 4 : 1,
        shadowColor: gradientColors[0].withValues(alpha: 0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Date badge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(DateTime.parse(agenda['dateTime'])),
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM').format(DateTime.parse(agenda['dateTime'])),
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agenda['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if ((agenda['description'] as String?)?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            agenda['description'],
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                            const SizedBox(width: 4),
                            Text(
                              controller.formatTime(agenda['dateTime']),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isUpcoming ? 'Upcoming' : 'Past',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // Actions
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgendaFormSheet extends GetView<AgendaController> {
  final bool isEdit;

  const _AgendaFormSheet({required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              isEdit ? 'Edit Agenda' : 'Add New Agenda',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Title field
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter agenda title',
                prefixIcon: const Icon(Icons.title_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Description field
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter agenda description',
                prefixIcon: const Icon(Icons.description_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Date & Time pickers
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _DateTimeButton(
                      icon: Icons.calendar_today_rounded,
                      label: DateFormat('EEE, dd MMM').format(controller.selectedDate.value),
                      onTap: () => controller.pickDate(context),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => _DateTimeButton(
                      icon: Icons.access_time_rounded,
                      label: controller.selectedTime.value.format(context),
                      onTap: () => controller.pickTime(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.saveAgenda,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  isEdit ? 'Update Agenda' : 'Save Agenda',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}