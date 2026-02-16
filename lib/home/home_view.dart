part of 'home_controller.dart';

class _HomeView extends GetView<HomeController> {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(theme, isDark),
      body: Obx(() => IndexedStack(index: controller.currentIndex.value, children: controller.pages)),
      bottomNavigationBar: Obx(() => _buildBottomNavBar(theme, isDark)),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      title: Obx(() => Text(_getTitle())),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E3A5F), const Color(0xFF0D253F)]
                : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          ),
        ),
      ),
      foregroundColor: Colors.white,
    );
  }

  String _getTitle() {
    switch (controller.currentIndex.value) {
      case 0:
        return 'My Agenda';
      case 1:
        return 'AI Summary';
      case 2:
        return 'Profile';
      default:
        return 'Schedule App';
    }
  }

  Widget _buildBottomNavBar(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: isDark ? const Color(0xFF67A8E5) : const Color(0xFF667EEA),
          unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.event_note_outlined, 0),
              activeIcon: _buildNavIcon(Icons.event_note_rounded, 0, isActive: true),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.auto_awesome_outlined, 1),
              activeIcon: _buildNavIcon(Icons.auto_awesome_rounded, 1, isActive: true),
              label: 'Summary',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.person_outline_rounded, 2),
              activeIcon: _buildNavIcon(Icons.person_rounded, 2, isActive: true),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool isActive = false}) {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = isDark ? const Color(0xFF67A8E5) : const Color(0xFF667EEA);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(isActive ? 10 : 8),
      decoration: BoxDecoration(
        color: isActive ? selectedColor.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: isActive ? 26 : 24),
    );
  }
}