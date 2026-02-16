import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_storage/lite_storage.dart';

import '../mediator/i_mediator.dart';

part 'profile_view.dart';

class ProfileController extends GetxController {
  final IMediator _mediator;

  ProfileController(this._mediator);

  // Theme mode observable
  static final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Stats
  final RxInt totalAgendas = 0.obs;
  final RxInt upcomingAgendas = 0.obs;
  final RxInt pastAgendas = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
    _loadStats();
  }

  void _loadThemePreference() {
    final savedTheme = LiteStorage.read('theme_mode');
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          themeMode.value = ThemeMode.dark;
          break;
        default:
          themeMode.value = ThemeMode.system;
      }
    }
  }

  void _loadStats() {
    final agendas = _mediator.data.agendaItems;
    totalAgendas.value = agendas.length;

    final now = DateTime.now();
    upcomingAgendas.value = agendas.where((a) {
      final dateTime = DateTime.parse(a['dateTime'] as String);
      return dateTime.isAfter(now);
    }).length;

    pastAgendas.value = totalAgendas.value - upcomingAgendas.value;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    // Save preference
    String themeName;
    switch (mode) {
      case ThemeMode.light:
        themeName = 'light';
        break;
      case ThemeMode.dark:
        themeName = 'dark';
        break;
      default:
        themeName = 'system';
    }
    LiteStorage.write('theme_mode', themeName);
  }

  void clearAllData() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to clear all agendas and summaries? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // Clear agendas
              final agendas = List<Map<String, dynamic>>.from(_mediator.data.agendaItems);
              for (final agenda in agendas) {
                _mediator.data.removeAgendaItem(agenda['id'] as int);
              }

              // Clear from storage
              LiteStorage.write('agendas', <Map<String, dynamic>>[]);
              LiteStorage.write('summaries', <Map<String, dynamic>>[]);

              _loadStats();
              Get.back();
              Get.snackbar(
                'Data Cleared',
                'All agendas and summaries have been removed',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withValues(alpha: 0.8),
                colorText: Colors.white,
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Widget build() => _ProfileView();
  static Bindings bindings(IMediator mediator) => BindingsBuilder(() => Get.lazyPut(() => ProfileController(mediator)));
}