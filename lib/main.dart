import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shuchu/src/app.dart';

const userPrefsBox = 'user_prefs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(userPrefsBox);

  ValueListenable<Box> isDarkMode =
      Hive.box(userPrefsBox).listenable(keys: ['isDarkMode']);

  runApp(ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, box, widget) {
        return MaterialApp(
          themeMode: box.get('isDarkMode', defaultValue: false)
              ? ThemeMode.dark
              : ThemeMode.light,
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const MainApp(),
        );
      }));
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
        surfaceContainer: Color(0xFF363646),
        surface: surface,
        onSurface: foreground));

const Color foreground = Color(0xFFF8FBFF);
const Color error = Color(0xFFE82424);
const Color primary = Color(0xFF7E9CD8);
const Color secondary = Color(0xffffa066);
const Color surface = Color(0xff16161D);
