import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_checker/online_checker.dart' show OnlineChecker;
import 'package:shimmer/shimmer.dart';

import '../mediator/i_mediator.dart';

part 'summary_view.dart';

class SummaryController extends GetxController {
  final IMediator _mediator;

  SummaryController(this._mediator);

  // Observable state
  final RxString summary = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString lastUpdated = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedSummary();
  }

  void _loadCachedSummary() {
    final summaries = _mediator.data.summaryItems;
    if (summaries.isNotEmpty) {
      final latestSummary = summaries.last;
      summary.value = latestSummary['content'] as String? ?? '';
      lastUpdated.value = latestSummary['updatedAt'] as String? ?? '';
      log('SummaryController: Loaded cached summary');
    }
  }

  Future<void> generateSummary() async {
    if (!await OnlineChecker.isConnect()) {
      log('SummaryController: No internet connection');
      Get.snackbar(
        'No Internet',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final agendas = _mediator.data.agendaItems;

    if (agendas.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'No agendas available to summarize.\nAdd some agendas first!';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final prompt = _buildPrompt(agendas);
      log('SummaryController: Generating summary with prompt length: ${prompt.length}');

      final gemini = Gemini.instance;
      final response = await gemini.prompt(parts: [Part.text(prompt)]);

      if (response?.output != null && response!.output!.isNotEmpty) {
        summary.value = response.output!;
        lastUpdated.value = DateTime.now().toIso8601String();

        // Save to local storage
        _saveSummary(summary.value);

        log('SummaryController: Summary generated successfully');
      } else {
        throw Exception('Empty response from Gemini API');
      }
    } catch (e) {
      log('SummaryController: Error generating summary: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to generate summary.\n${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String _buildPrompt(List<Map<String, dynamic>> agendas) {
    final buffer = StringBuffer();
    buffer.writeln('Please provide a concise and helpful summary of my upcoming schedule/agenda items below.');
    buffer.writeln('Highlight any important items, conflicts, or suggestions for time management.');
    buffer.writeln('Format the response in a clear, readable way with sections if needed.');
    buffer.writeln('');
    buffer.writeln('My Agenda Items:');
    buffer.writeln('');

    for (int i = 0; i < agendas.length; i++) {
      final agenda = agendas[i];
      final dateTime = DateTime.parse(agenda['dateTime'] as String);
      final formattedDate = DateFormat('EEEE, dd MMMM yyyy HH:mm').format(dateTime);

      buffer.writeln('${i + 1}. ${agenda['title']}');
      buffer.writeln('   Date/Time: $formattedDate');
      if ((agenda['description'] as String?)?.isNotEmpty == true) {
        buffer.writeln('   Description: ${agenda['description']}');
      }
      buffer.writeln('');
    }

    return buffer.toString();
  }

  void _saveSummary(String content) {
    final summaryData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'content': content,
      'updatedAt': DateTime.now().toIso8601String(),
      'agendaCount': _mediator.data.agendaItems.length,
    };

    // Check if we already have a summary, update it instead of adding
    final summaries = _mediator.data.summaryItems;
    if (summaries.isNotEmpty) {
      summaryData['id'] = summaries.first['id'];
      _mediator.data.updateSummaryItem(summaryData);
    } else {
      _mediator.data.addSummaryItem(summaryData);
    }
  }

  String get formattedLastUpdated {
    if (lastUpdated.value.isEmpty) return '';
    try {
      final date = DateTime.parse(lastUpdated.value);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  static Widget build() => _SummaryView();
  static Bindings bindings(IMediator mediator) => BindingsBuilder(() => Get.lazyPut(() => SummaryController(mediator)));
}