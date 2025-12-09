import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class CustomNavigator {
  CustomNavigator._singleTone();

  static final CustomNavigator _instance = CustomNavigator._singleTone();

  static CustomNavigator get instance => _instance;

  void pop({dynamic object}) {
    Navigator.pop(navigatorKey.currentContext!, object);
  }

  Future<T> push<T>({required Widget routeWidget}) async {
    return await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => routeWidget),
    );
  }
}
