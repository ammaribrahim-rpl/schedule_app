import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../mediator/i_mediator.dart';

part 'agenda_view.dart';

class AgendaController extends GetxController {
  final IMediator _mediator;

  AgendaController(this._mediator);

  // Observable state
  final RxList<Map<String, dynamic>> agendas = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  // Edit mode
  final RxnInt editingId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _loadAgendas();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Filtered agendas based on search query
  List<Map<String, dynamic>> get filteredAgendas {
    if (searchQuery.value.isEmpty) return agendas;
    return agendas.where((agenda) {
      final title = (agenda['title'] as String).toLowerCase();
      final desc = (agenda['description'] as String?)?.toLowerCase() ?? '';
      final query = searchQuery.value.toLowerCase();
      return title.contains(query) || desc.contains(query);
    }).toList();
  }

  // Group agendas by date
  Map<String, List<Map<String, dynamic>>> get groupedAgendas {
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (var agenda in filteredAgendas) {
      final date = DateTime.parse(agenda['dateTime'] as String);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      if (groups[dateKey] == null) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(agenda);
    }
    return groups;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void _loadAgendas() {
    agendas.assignAll(_mediator.data.agendaItems);
    _sortAgendas();
  }

  void _sortAgendas() {
    agendas.sort((a, b) {
      final dateA = DateTime.parse(a['dateTime'] as String);
      final dateB = DateTime.parse(b['dateTime'] as String);
      return dateA.compareTo(dateB);
    });
  }

  void showAddAgendaSheet(BuildContext context) {
    _resetForm();
    _showFormSheet(context, isEdit: false);
  }

  void showEditAgendaSheet(BuildContext context, Map<String, dynamic> agenda) {
    editingId.value = agenda['id'] as int;
    titleController.text = agenda['title'] as String;
    descriptionController.text = agenda['description'] as String? ?? '';
    final dateTime = DateTime.parse(agenda['dateTime'] as String);
    selectedDate.value = dateTime;
    selectedTime.value = TimeOfDay.fromDateTime(dateTime);
    _showFormSheet(context, isEdit: true);
  }

  void _showFormSheet(BuildContext context, {required bool isEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AgendaFormSheet(isEdit: isEdit),
    );
  }

  void _resetForm() {
    editingId.value = null;
    titleController.clear();
    descriptionController.clear();
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: selectedTime.value);
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void saveAgenda() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Title cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    final dateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    final agenda = {
      'id': editingId.value ?? DateTime.now().millisecondsSinceEpoch,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'dateTime': dateTime.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    if (editingId.value != null) {
      _mediator.data.updateAgendaItem(agenda);
      Get.snackbar(
        'Success',
        'Agenda updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } else {
      _mediator.data.addAgendaItem(agenda);
      Get.snackbar(
        'Success',
        'Agenda added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }

    _loadAgendas();
    Get.back();
    _resetForm();
  }

  void deleteAgenda(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Agenda'),
        content: const Text('Are you sure you want to delete this agenda?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _mediator.data.removeAgendaItem(id);
              _loadAgendas();
              Get.back();
              Get.snackbar(
                'Deleted',
                'Agenda removed',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.withValues(alpha: 0.8),
                colorText: Colors.white,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  String formatTime(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('HH:mm').format(date);
  }

  bool isUpcoming(String isoDate) {
    final date = DateTime.parse(isoDate);
    return date.isAfter(DateTime.now());
  }

  static Widget build() => _AgendaView();
  static Bindings bindings(IMediator mediator) => BindingsBuilder(() => Get.lazyPut(() => AgendaController(mediator)));
}