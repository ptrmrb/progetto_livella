import 'package:flutter/material.dart';
import '../model/support/app_localizations.dart';
import 'pages/converter_page.dart';
import 'pages/home_page.dart';
import 'package:utility_toolset/app.dart';
import 'pages/settings_page.dart';

class MainLayout extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode?) onThemeChanged;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const MainLayout({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            SettingsPage(
              currentThemeMode: currentThemeMode,
              onThemeChanged: onThemeChanged,
              currentLocale: currentLocale,
              onLocaleChanged: onLocaleChanged,
            ),
            const HomePage(),
            const ConverterPage(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
          child: Container(
            height: 85.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: (brightness == Brightness.light)
                  ? Colors.grey.shade900
                  : Colors.grey.shade800,

              border: Border.all(color: Colors.black12, width: 4),
              borderRadius: BorderRadius.circular(30),
            ),

            child: TabBar(
              labelColor: Colors.green, //colore della icona selezionata nella bnb
              unselectedLabelColor: Colors.white60, // colore delle icone non selezionate nelle bnb
              indicatorColor: Colors.transparent,
              splashBorderRadius: BorderRadius.circular(30.0),
              dividerHeight: 0.0,

              // modificatori dimensione della pillola
              indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: -20.0, // Meno padding laterale -> più larga
                  vertical: 15.0    // Più padding verticale -> più bassa/schiacciata
              ),

              // colori della pillola
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),

              tabs: [
                const Tab(
                  icon: Icon(Icons.settings_rounded, size: 35.0),
                ),
                Tab(
                  icon: Transform.scale(
                    scale: 1.5, // Aumenta questo valore se serve (es. 1.8)
                    child: const ImageIcon(
                      AssetImage('assets/images/livella_icon.png'),
                      size: 40.0, // Dimensione base
                    ),
                  ),
                ),
                const Tab(
                  icon: Icon(Icons.swap_horiz_rounded, size: 35.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}