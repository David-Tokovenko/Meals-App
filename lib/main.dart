import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter (для Material Design)
import 'package:google_fonts/google_fonts.dart'; // Імпорт пакета для використання шрифтів Google
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Імпорт пакета Riverpod для управління станом

import 'package:meals/screens/tabs.dart'; // Імпорт файлу, що містить віджет головного екрану з вкладками

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
);


void main() {
  // Головна функція, яка запускається при старті застосунку
  runApp(
    const ProviderScope(child: App()),
  ); // Запуск Flutter-застосунку, обгорнутого в ProviderScope (для Riverpod)
}

// Кореневий віджет застосунку, є StatelessWidget
class App extends StatelessWidget {
  const App({super.key}); // Конструктор віджета App

  @override
  Widget build(BuildContext context) {
    // Метод build описує UI, який буде відображено для цього віджета
  return MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system, // Автоматичне перемикання
  home: const TabsScreen(),
);
  } // Метод, що повертає MaterialApp з темою та головним екраном
} // Кінець класу App
