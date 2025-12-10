import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // per SystemChrome
import 'app.dart';

void main() {
  // Assicuro che i binding siano inizializzati
  WidgetsFlutterBinding.ensureInitialized();

  // Blocco l'orientamento dell'app in portrait up per evitare rotazioni dell'UI indesiderate.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const App());
  });
}