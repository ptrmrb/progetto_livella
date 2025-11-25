import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utility_toolset/model/support/app_localizations.dart';
import 'UI/layout.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', '');

  void _changeThemeMode(ThemeMode? newMode) {
    if (newMode != null) {
      setState(() {
        _themeMode = newMode;
      });
    }
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility Toolset',

      // --- TEMA CHIARO ---
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),

      // --- TEMA SCURO ---
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),

      themeMode: _themeMode,
      locale: _locale,

      supportedLocales: const [
        Locale('en', ''),
        Locale('it', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      // Ora MainLayout sarà riconosciuto correttamente grazie all'import package:
      home: MainLayout(
        currentThemeMode: _themeMode,
        onThemeChanged: _changeThemeMode,
        currentLocale: _locale,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}