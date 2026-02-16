import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

import '../mediator/i_mediator.dart';

part 'splash_view.dart';

class SplashController extends GetxController {
  final IMediator _mediator;

  SplashController(this._mediator);

  @override
  void onReady() {
    super.onReady();
    _initialize();
  }

  Future<void> _initialize() async {
    log('SplashController: initialize');

    await Future.delayed(const Duration(milliseconds: 100));

    // Initialize Gemini API
    Gemini.init(apiKey: 'AIzaSyDwRIXjAl5GO8KOYEr3sacEqXcRJKXA_9I');

    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    _navigateToHome();
  }

  static Widget build() => const _SplashView();
  static Bindings bindings(IMediator mediator) => BindingsBuilder(() {
    Get.put(SplashController(mediator));
  });
  static const String goToHome = 'goToHome';
  void _navigateToHome() => _mediator.navigateTo(goToHome);
}
