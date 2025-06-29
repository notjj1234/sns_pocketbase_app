// lib/pages/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:sns_pocketbase_app/utils/translations.dart'; // Import added

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslation('settings', languageProvider.currentLanguage), // Updated line
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslation('theme', languageProvider.currentLanguage), // Updated line
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(
                getTranslation('Dark Mode', languageProvider.currentLanguage), // Updated line
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(); // Toggle theme in the provider
              },
            ),
            const SizedBox(height: 20), // Add spacing between sections
            Text(
              getTranslation('language', languageProvider.currentLanguage), // Updated line
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(
                languageProvider.currentLanguage == 'en'
                    ? getTranslation('English', 'en') // Updated line
                    : getTranslation('Japanese', 'ja'), // Updated line
              ),
              value: languageProvider.currentLanguage == 'ja', // Toggle to Japanese if true
              onChanged: (bool isJapanese) {
                String newLanguage = isJapanese ? 'ja' : 'en';
                languageProvider.changeLanguage(newLanguage); // Remove `await` if `changeLanguage` is void
              },
            ),
          ],
        ),
      ),
    );
  }
}
