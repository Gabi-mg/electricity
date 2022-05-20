import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xFF1a6699);

  static ThemeData theme = ThemeData(
    primaryColor: CustomTheme.primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
    ),
    fontFamily: 'Roboto',
  );
}
