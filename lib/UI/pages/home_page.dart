import 'dart:async'; // Per gestire lo Stream
import 'dart:math'; // Per calcoli matematici
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; // pacchetto sensori
import '../../model/support/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // memorizzare i valori dell'accelerometro
  double _x = 0.0;
  double _y = 0.0;

  // Sottoscrizione allo stream dei sensori
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    // Iniziamo ad ascoltare i sensori appena la pagina viene aperta
    _startListening();
  }

  @override
  void dispose() {
    // cancello la sottoscrizione quando si chiude la pagina per evitare memory leak.
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    // Ci abboniamo al flusso di eventi dell'accelerometro
    _streamSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // aggiorniamo costantemente lo stato con i nuovi valori rilevati dai sensori.
      // x > 0 inclinato a sinistra, x < 0 a destra
      // y > 0 inclinato in basso, y < 0 in alto
      setState(() {
        _x = event.x;
        _y = event.y;
      });
    });
  }

  // Funzione helper per calcolare la posizione della bolla
  // Restituisce un Alignment (da -1.0 a 1.0) basato sull'inclinazione
  Alignment _getBubbleAlignment() {
    // I valori dell'accelerometro vanno circa da -10 a 10 (m/s^2).
    // Dividiamo per un fattore per "calibrare" la sensibilità.
    // Più basso è il divisore, più la bolla è sensibile.
    const double sensitivity = 5.0;


    // La bolla deve andare verso l'alto se inclino la parte superiore del dispositivo in alto
    // La bolla deve andare verso destra se inclino la parte sinistra del dispositivo verso destra
    double alignX = -_x / sensitivity;
    double alignY = _y / sensitivity; // Spesso la Y va invertita su mobile

    // blocco i valori tra -1.0 e 1.0 per non far uscire la bolla dal cerchio
    if (alignX > 1.0) alignX = 1.0;
    if (alignX < -1.0) alignX = -1.0;
    if (alignY > 1.0) alignY = 1.0;
    if (alignY < -1.0) alignY = -1.0;

    return Alignment(alignX, alignY);
  }

  // determinare il colore della bolla (Verde se in bolla, Rosso se fuori)
  Color _getBubbleColor() {
    // Se l'inclinazione è minima (vicino a 0), siamo "in bolla"
    if (_x.abs() < 0.5 && _y.abs() < 0.5) {
      return Colors.green; // Colore successo
    } else {
      return Colors.redAccent; // Colore fuori bolla
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(

        title: Text(
          AppLocalizations.of(context)!.translate('livella'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // SEZIONE GRAFICA ( livella torica )
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // bersaglio esterno
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainer,
                border: Border.all(
                  color: onSurface.withOpacity(0.5),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),

              // uso uno Stack per sovrapporre gli elementi
              child: Stack(
                children: [
                  // bersaglio interno
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: onSurface.withOpacity(0.3), width: 2),
                      ),
                    ),
                  ),
                  // linee a croce
                  Center(child: Container(width: 280, height: 1, color: onSurface.withOpacity(0.1))),
                  Center(child: Container(width: 1, height: 280, color: onSurface.withOpacity(0.1))),

                  // la bolla mobile
                  // animazione
                  AnimatedAlign( // permette alla bolla di muoversi
                    duration: const Duration(milliseconds: 100), // Piccola latenza per aggiungere fluidità
                    alignment: _getBubbleAlignment(),
                    //grafica
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getBubbleColor(),
                        boxShadow: [
                          BoxShadow(
                            color: _getBubbleColor().withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // distanza tra il bersaglio esterno e i widget che contengono le info
          const SizedBox(height: 50),

          // Widget Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoCard("Roll (X)", _x),
              _buildInfoCard("Pitch (Y)", _y),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, double value) {
    return Card(
      elevation: 5, //ombra widget
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),  //altezza box
            Text(
              value.toStringAsFixed(2), // mostra solo 2 decimali
              style: TextStyle(
                fontSize: 24,
                // cambia colore se il valore è lontano da 0
                color: value.abs() < 0.5 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}