import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  void pop<T>([T? result]) {
    return Navigator.pop<T>(this, result);
  }

  Future<T?> push<T extends Object?>(Route<T> route) {
    return Navigator.push(this, route);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) {
    return Navigator.pushReplacement<T, TO>(this, newRoute, result: result);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(this, routeName,
        arguments: arguments, result: result);
  }

  Future<bool> maybePop<T extends Object?>(BuildContext context, [T? result]) {
    return Navigator.maybePop<T>(this, result);
  }
}
