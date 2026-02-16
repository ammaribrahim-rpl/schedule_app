import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../agenda/agenda_controller.dart';
import '../mediator/i_mediator.dart';
import '../profile/profile_controller.dart';
import '../summary/summary_controller.dart';

part 'home_view.dart';

class HomeController extends GetxController {
  // Current tab index
  final RxInt currentIndex = 0.obs;

  // Tab pages
  final List<Widget> pages = [AgendaController.build(), SummaryController.build(), ProfileController.build()];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  static Widget build() => const _HomeView();

  static Bindings bindings(IMediator mediator) => BindingsBuilder(() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AgendaController(mediator));
    Get.lazyPut(() => SummaryController(mediator));
    Get.lazyPut(() => ProfileController(mediator));
  });

  static const String goToSummary = 'goToSummary';
}