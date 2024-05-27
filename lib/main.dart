import 'package:flutter/material.dart';
import 'package:shuchu/src/app.dart';

void main() {
  runApp(MaterialApp(
    theme: themeData,
    home: const MainApp(),
  ));
}

ThemeData? themeData = ThemeData(
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

const Color foreground = Color(0xFFDCD7BA);
const Color error = Color(0xFFE82424);
const Color primary = Color(0xFF7E9CD8);
const Color secondary = Color(0xFFFFA066);
const Color surface = Color(0xFF16161D);
