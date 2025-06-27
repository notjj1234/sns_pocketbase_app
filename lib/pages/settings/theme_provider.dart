// lib/settings/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    // Load saved theme mode from shared preferences
    _loadThemeFromPreferences();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPreferences();
    notifyListeners(); // Notify listeners of the change
  }

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black87), // Ensure body text is visible in light mode
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }




  void _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to dark mode
    notifyListeners();
  }

  void _saveThemeToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
