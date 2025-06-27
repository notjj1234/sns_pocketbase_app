// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/login/login_page.dart';
import 'package:sns_pocketbase_app/pages/feed/feed_page.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns_pocketbase_app/pages/settings/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isUserRemembered = await _checkIfUserIsRemembered();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId') ?? '';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(
        initialPage: isUserRemembered
            ? FeedPage(userId: userId, email: prefs.getString('email') ?? '', onLogout: () {})
            : LoginPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: AppConfig.appName,
          theme: themeProvider.isDarkMode ? themeProvider.darkTheme : themeProvider.lightTheme,
          home: initialPage,
          locale: Locale(languageProvider.currentLanguage),
          supportedLocales: const [
            Locale('en'),
            Locale('ja'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}

Future<bool> _checkIfUserIsRemembered() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('rememberMe') ?? false;
}
