import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../model/support/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode?) onThemeChanged;

  // --- MODIFICA 1: Parametri Lingua ---
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const SettingsPage({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // Helper per Tema
  int _getThemeIndex() {
    switch (widget.currentThemeMode) {
      case ThemeMode.light: return 0;
      case ThemeMode.dark: return 1;
      case ThemeMode.system: default: return 2;
    }
  }

  // --- MODIFICA 2: Helper per Lingua ---
  // 0 = Inglese, 1 = Italiano
  int _getLocaleIndex() {
    if (widget.currentLocale.languageCode == 'it') {
      return 1;
    }
    return 0; // Default Inglese
  }

  @override
  Widget build(BuildContext context) {
    // Stile comune per i titoli
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        // --- MODIFICA: Aggiunto stile bold ---
        title: Text(
          AppLocalizations.of(context)!.translate('impostazioni'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),



      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- SEZIONE TEMA ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.translate('Tema'), style: titleStyle),
                ToggleSwitch(
                  minWidth: 70.0,
                  minHeight: 50.0,
                  initialLabelIndex: _getThemeIndex(),
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[300],
                  inactiveFgColor: Colors.grey[800],
                  totalSwitches: 3,
                  icons: const [
                    FontAwesomeIcons.sun,
                    FontAwesomeIcons.solidMoon,
                    FontAwesomeIcons.gear,
                  ],
                  iconSize: 20.0,
                  activeBgColors: const [
                    [Colors.orange, Colors.yellow],
                    [Colors.black87, Colors.black54],
                    [Colors.blue, Colors.blueAccent],
                  ],
                  animate: true,
                  curve: Curves.decelerate,
                  onToggle: (index) {
                    if (index == 0) widget.onThemeChanged(ThemeMode.light);
                    else if (index == 1) widget.onThemeChanged(ThemeMode.dark);
                    else widget.onThemeChanged(ThemeMode.system);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30), // Spazio tra le sezioni

            // SEZIONE LINGUA
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.translate('Lingua'), style: titleStyle),
                ToggleSwitch(
                  minWidth: 90.0, // Un po' più largo per le icone
                  minHeight: 50.0,
                  initialLabelIndex: _getLocaleIndex(),
                  cornerRadius: 20.0,

                  activeFgColor: Colors.black,
                  inactiveBgColor: Colors.grey[300],
                  inactiveFgColor: Colors.grey[800],

                  totalSwitches: 2, // Solo EN e IT

                  // Usiamo labels (testo) o customWidgets se vogliamo bandiere.
                  // Per semplicità usiamo icone o testo. Qui uso icone bandiera (font awesome)
                  // o testo semplice "EN" "IT". Usiamo icone FontAwesome per coerenza.
                  icons: const [
                    FontAwesomeIcons.flagUsa, // EN
                    FontAwesomeIcons.pizzaSlice,  // IT (simbolo generico o bandiera se c'è)
                  ],

                  customTextStyles: [
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ],
                  labels: const ['EN', 'IT'],

                  iconSize: 20.0,

                  // Colori: Blu per EN, Verde per IT (colori bandiere approx)
                  activeBgColors: const [
                    [Colors.blue, Colors.red],
                    [Colors.green, Colors.white, Colors.red],
                  ],

                  animate: true,
                  curve: Curves.decelerate,

                  onToggle: (index) {
                    if (index == 0) {
                      widget.onLocaleChanged(const Locale('en', ''));
                    } else {
                      widget.onLocaleChanged(const Locale('it', ''));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}