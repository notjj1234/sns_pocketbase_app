import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  void _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('preferred_language') ?? 'en';
    notifyListeners(); // Ensure listeners are notified when language is loaded
  }

  void changeLanguage(String newLanguage) async {
    if (newLanguage != _currentLanguage) {
      _currentLanguage = newLanguage;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_language', newLanguage);
      print('Language set in SharedPreferences: $newLanguage');
      notifyListeners(); // Notify listeners of the language change
    }
  }
}
