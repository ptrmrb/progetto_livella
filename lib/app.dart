import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Per localizzazione
import 'UI/layout.dart'; // Il nostro Layout principale [Lezione 4]
import 'model/support/app_localizations.dart'; // Classe helper [Lezione 4]

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

      //TEMA Chiaro
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white70, // testo e icone bianchi
        ),
        scaffoldBackgroundColor: Colors.grey.shade200, // colore sfondo modalità chiara
        useMaterial3: true,
      ),

      // TEMA SCURO (Dark)
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade500,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white, // testo e icone bianchi
        ),
        scaffoldBackgroundColor: Colors.grey.shade900, // colore sfondo modalità scura
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

      home: MainLayout(
        currentThemeMode: _themeMode,
        onThemeChanged: _changeThemeMode,
        currentLocale: _locale,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}