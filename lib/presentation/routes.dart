import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/presentation/screens/home/page/home_screen.dart';
import 'package:flutter/material.dart';

class Routers {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
