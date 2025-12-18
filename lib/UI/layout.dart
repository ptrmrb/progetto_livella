import 'package:flutter/material.dart';
import 'package:utility_toolset/UI/pages/history_page.dart';
import 'pages/converter_page.dart';
import 'pages/home_page.dart';
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            SettingsPage(
              currentThemeMode: currentThemeMode,
              onThemeChanged: onThemeChanged,
              currentLocale: currentLocale,
              onLocaleChanged: onLocaleChanged,
            ),
            const HistoryPage(),
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
                  ? Colors.grey.shade400
                  : Colors.grey.shade800,
              border: Border.all(
                  color:  (brightness == Brightness.light)
                  ? Colors.white38
                  : Colors.black12,
                  width: 4),
              borderRadius: BorderRadius.circular(40),
            ),

            child: TabBar(
              labelColor: Colors.green, //colore della icona selezionata nella bnb
              unselectedLabelColor:(brightness == Brightness.light) // colore delle icone non selezionate nelle bnb
                  ? Colors.grey.shade800
                  : Colors.white60,
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
                borderRadius: BorderRadius.circular(40),
              ),

              tabs: [
                const Tab(
                  icon: Icon(Icons.settings_rounded, size: 35.0),
                ),
                const Tab(
                  icon: Icon(Icons.history, size: 35.0),
                ),
                Tab(
                  icon: Transform.scale(
                    scale: 1.7,
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