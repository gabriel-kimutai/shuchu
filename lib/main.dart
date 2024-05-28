import 'package:flutter/material.dart';
import 'package:shuchu/src/app.dart';

void main() {
  runApp(MaterialApp(
    theme: themeData,
    home: const MainApp(),
  ));
}

ThemeData? themeData = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: foreground,
        secondary: secondary,
        onSecondary: foreground,
        error: error,
        onError: foreground,
        surface: surface,
        onSurface: foreground));

const Color foreground = Color(0xFFF8FBFF);
const Color error = Color(0xFFE82424);
const Color primary = Color(0xFF7E9CD8);
const Color secondary = Color(0xffffa066);
const Color surface = Color(0xff16161D);
