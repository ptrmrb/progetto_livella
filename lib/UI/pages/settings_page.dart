import 'package:flutter/material.dart';
import '../../model/support/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Aggiungiamo uno Scaffold e una AppBar a QUESTA pagina
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('impostazioni')),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pagina Impostazioni (View 0)'),
      ),
    );
  }
}