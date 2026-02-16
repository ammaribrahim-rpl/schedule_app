import 'dart:developer' show log;

import 'package:get/get.dart';
import 'package:lite_storage/lite_storage.dart';

import '../home/home_controller.dart';
import '../splash/splash_controller.dart';
import 'i_mediator.dart';
import 'i_mediator_data.dart';

part 'mediator_data.dart';

class Mediator implements IMediator {
  static late Mediator instance;

  @override
  IMediatorData get data => MediatorData();

  @override
  Future<void> navigateTo(String routeName, {Object? arguments}) async {
    log('Navigator: navigating to $routeName');
    if (routeName == SplashController.goToHome) {
      return await Get.offNamedUntil(_home, (route) => false);
    }
    log('Navigator: route not found $routeName');
    return Future.value();
  }

  static String get title => 'Schedule App';
  static String get initialRoute => _splash;
  static List<GetPage<dynamic>> get getPages => [
    GetPage(name: _splash, page: () => SplashController.build(), binding: SplashController.bindings(instance)),
    GetPage(name: _home, page: () => HomeController.build(), binding: HomeController.bindings(instance)),
  ];

  static const String _splash = '/splash';
  static const String _home = '/home';
}