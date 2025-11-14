import 'package:flutter/material.dart';
import '../model/support/app_localizations.dart';
import 'pages/converter_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';

// Come da slide Lezione 4, slide 4
class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Il DefaultTabController gestisce la sincronia tra le schede
    return DefaultTabController(
      length: 3, // Il nostro numero di schede
      child: Scaffold(

        // Il body contiene le pagine che cambiano
        body: const TabBarView(
          children: [
            SettingsPage(), // Pagina 0
            HomePage(), // Pagina 1
            ConverterPage(), // Pagina 2
          ],
        ),
        bottomNavigationBar: Padding( // padding per spostare la bottom navigation bar rispetto allo schermo
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Container(
            height: 80.0, // altezza interna della bottom navigation bar

            decoration: BoxDecoration(
              //bordo della navigation bar
              border: Border.all(color: Colors.black12, width: 4),
              borderRadius:
              BorderRadius.circular(30), // angolo dei bordi della navigation bar
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10),
              ],
            ),

            child: TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
              Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor:
              Colors.transparent, //nascondiamo la linea che compare sotto l'icona attiva
              dividerHeight: 0.0, // nascondo linea bianca - divisore

              // Allineo il raggio dello splash a quello del container
              splashBorderRadius: BorderRadius.circular(
                  30.0),

              tabs: const [
                // Scheda 0: Impostazioni
                Tab(
                  icon: Icon(Icons.settings_rounded, size: 30.0),
                ),
                // Scheda 1: Livella
                Tab(
                  icon: ImageIcon(
                    AssetImage('assets/images/livella_icon.png'), // icona personalizzata
                    size: 43.0,
                  ),
                ),
                // Scheda 2: Convertitore
                Tab(
                  icon: Icon(Icons.swap_horiz_rounded, size: 30.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}