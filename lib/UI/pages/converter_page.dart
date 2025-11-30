import 'package:flutter/material.dart';
import '../../model/support/app_localizations.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('convertitore'),
        ),
      ),
      body: const Center(
        child: Text('Pagina Convertitore (View 2)'),
      ),
    );
  }
}