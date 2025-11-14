import 'package:flutter/material.dart';
import '../../model/support/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Aggiungiamo uno Scaffold e una AppBar a QUESTA pagina
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('livella')),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pagina Livella (View 1)'),
      ),
    );
  }
}