import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart'; // Per temi dinamici [Lezione 4]
import 'package:flutter_localizations/flutter_localizations.dart'; // Per localizzazione
import 'UI/layout.dart'; // Il nostro Layout principale [Lezione 4]
import 'model/support/app_localizations.dart'; // Classe helper [Lezione 4]

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // Definizioni colori default [Lezione 4, slide 9]
  static final _defaultLightColorScheme =
  ColorScheme.fromSwatch(primarySwatch: Colors.green);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.green, brightness: Brightness.dark);

  @override

  Widget build(BuildContext context) {
    // costruisco l'app usando DynamicColorBuilder [Lezione 4, slide 9]
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Utility Toolset', // titolo provvisorio

          // IMPOSTAZIONE TEMI
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system, // Usa il tema di sistema

          // IMPOSTAZIONI LINGUA
          supportedLocales: const [
            Locale('en', ''), // Inglese
            Locale('it', ''), // Italiano
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate, // Il nostro delegate custom
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
            return supportedLocales.first; // Default a Inglese
          },
          // Puntiamo al widget Layout
          home: const MainLayout(),
        );
      },
    );
  }
}