import 'package:flutter/material.dart';
import 'app.dart'; // Import del file App.dart

void main() {
  // Assicuro che i binding siano inizializzati
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const App(),
  );
}