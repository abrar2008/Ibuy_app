import 'package:ibuy_mac_1/services/auth_service.dart';
import 'package:flutter/material.dart';

class CustomProvider extends InheritedWidget {
  final AuthService auth;
  final db;

  CustomProvider({Key key, Widget child, this.auth, this.db }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static CustomProvider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<CustomProvider>());
}