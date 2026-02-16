import 'i_mediator_data.dart';

abstract class IMediator {
  IMediatorData get data;
  Future<void> navigateTo(String routeName, {Object? arguments});
}