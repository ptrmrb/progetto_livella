import 'dart:async'; // Per la gestione degli stream (sensori)
import 'dart:math'; // Per funzioni matematiche (atan, pi)
import 'package:flutter/material.dart'; // Framework UI
import 'package:sensors_plus/sensors_plus.dart'; // Pacchetto sensori
import '../../model/support/app_localizations.dart'; // Per le traduzioni

// Widget Stateful per la pagina principale
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dati grezzi dell'accelerometro
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;

  // Sottoscrizione allo stream dei sensori
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startListening(); // Avvia l'ascolto dei sensori all'inizializzazione
  }

  @override
  void dispose() {
    _streamSubscription?.cancel(); // Cancella la sottoscrizione alla chiusura
    super.dispose();
  }

  // Funzione per iniziare ad ascoltare i dati dell'accelerometro
  void _startListening() {
    _streamSubscription = accelerometerEvents.listen(
          (AccelerometerEvent event) {
        if (mounted) {
          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
        }
      },
      // Gestione errori nel caso il sensore non sia disponibile, visto in lezione 9
      onError: (error) {
        debugPrint("Errore Accelerometro: $error");
      },
      cancelOnError: true, // Chiude lo stream se c'è un errore critico
    );
  }

  // Determina se il dispositivo è piatto (modalità livella torica)
  bool _isFlat() {
    return _z.abs() > _x.abs() && _z.abs() > _y.abs();
  }

  // Converte il valore dell'accelerometro in gradi
  double _calculateDegrees(double value) {
    double angleRadians = atan(value / 9.81); // /9.81 perche' otteniamo valori di accelerazione
    return angleRadians * (180 / pi);
  }

  // CALCOLI ALLINEAMENTO BOLLA
  // Allineamento per la livella torica
  Alignment _getBubbleAlignmentToric() {
    const double sensitivity = 5.0;
    double alignX = _x / sensitivity;
    double alignY = -_y / sensitivity;

    // vincoli dei valori tra -1.0 e 1.0 per non uscire dalla grafica
    if (alignX > 1.0) alignX = 1.0;
    if (alignX < -1.0) alignX = -1.0;
    if (alignY > 1.0) alignY = 1.0;
    if (alignY < -1.0) alignY = -1.0;

    return Alignment(alignX, alignY);
  }

  // Allineamento per la livella lineare (barra)
  Alignment _getBubbleAlignmentLinear(double value, bool isPortrait) {
    const double sensitivity = 5.0;
    double alignment = value / sensitivity; // La bolla va opposta alla gravità

    // vincoli di valori
    if (alignment > 1.0) alignment = 1.0;
    if (alignment < -1.0) alignment = -1.0;

    // Restituisce l'allineamento in base all'orientamento
    if (isPortrait) {
      return Alignment(alignment, 0.0); // Muovi su X per modalità ritratto
    } else {
      return Alignment(0.0, -alignment); // Muovi su Y per modalità landscape
    }
  }

  // Restituisce il colore della bolla (verde se a livello, rosso altrimenti)
  Color _getBubbleColor(bool isLevel) {
    return isLevel ? Colors.green : Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    // Determinazione dello Stato
    bool flatMode = _isFlat();
    bool isPortrait = _y.abs() > _x.abs();

    // Calcolo valori per la modalità lineare
    double relevantValue = isPortrait ? _x : _y;
    double angle = _calculateDegrees(relevantValue);

    // Verifica se è "in bolla"
    bool isLevel = flatMode
        ? (_x.abs() < 0.5 && _y.abs() < 0.5)
        : (angle.abs() < 1.0);

    // Parametri per il Morphing della Fiala
    double width = flatMode ? 300.0 : (isPortrait ? 300.0 : 70.0);
    double height = flatMode ? 300.0 : (isPortrait ? 70.0 : 300.0);
    double borderRadius = flatMode ? 150.0 : 35.0;

    // Calcolo allineamento target della bolla
    Alignment targetAlignment = flatMode
        ? _getBubbleAlignmentToric()
        : _getBubbleAlignmentLinear(relevantValue, isPortrait);

    // Parametri per Testi e Rotazione
    String titleText = flatMode
        ? AppLocalizations.of(context)!.translate('MODALITA_PIANO')
        : (isPortrait
        ? AppLocalizations.of(context)!.translate('MODALITA_VERTICALE')
        : AppLocalizations.of(context)!.translate('MODALITA_ORIZZONTALE') );

    int textTurns = 0;
    bool isLandscapeLeft = false; // Flag per capire se siamo in modalita landscape sinistra (x < 0)
    if (!flatMode && !isPortrait) {
      // Se x > 0, Landscape Left (rotazione 1).
      // Se x < 0, Landscape Right (rotazione 3).
      isLandscapeLeft = _x > 0;
      textTurns = isLandscapeLeft ? 1 : 3;
    }

    // Definiamo la transizione personalizzata (Fade + Scale)
    Widget transitionBuilder(Widget child, Animation<double> animation) {
      return FadeTransition(  //dissolvenza
        opacity: animation,
        child: ScaleTransition(   //comparsa
          scale: animation,
          child: child,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('livella'),
        ),
      ),
      // Usiamo uno Stack per posizionare liberamente gli elementi
      body: Stack(
        alignment: Alignment.center, // Centro dello stack come punto di riferimento
        children: [
          // 1. LA FIALA CENTRALE (Gestisce il proprio morphing)
          _buildAnimatedLevelContainer(
              width, height, borderRadius, onSurface, targetAlignment, isLevel,
              flatMode, isPortrait, onSurface
          ),
          // 2. IL TITOLO (Animato in posizione e rotazione)
          AnimatedAlign(
            // Posizione: in alto per Portrait/Flat.
            // Per Landscape: se siamo a sinistra (x > 0), titolo a destra (-0.8). Se a destra (x < 0), titolo a sinistra (-0.8).
            alignment: (flatMode )
                ? const Alignment(0.0, -0.8)
                : ( isPortrait ? const Alignment(0.0, -0.5)
                : (isLandscapeLeft ? const Alignment(0.7, 0.0) : const Alignment(-0.7, 0.0))),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInExpo,
            child: AnimatedSwitcher(  // serve per scambiare le caselle di testo aggiungendo un animazione
              duration: const Duration(milliseconds: 300),
              transitionBuilder: transitionBuilder,
              // Switch tra titolo normale e ruotato
              child: (flatMode || isPortrait)
                  ? _buildModeTitle(titleText, key: ValueKey(titleText + "port")) // aggiungiamo una ValueKey per comunica all'animated switcher che il contenuto del widget è cambiato
                  : RotatedBox(
                quarterTurns: textTurns,
                child: _buildModeTitle(titleText, key: ValueKey(titleText + "land")),
              ),
            ),
          ),

          // 3. INFO CARD LINEARE
          AnimatedAlign(
            // Posizione: in basso per Portrait.
            // Per Landscape: invertito rispetto al titolo.
            alignment: (flatMode || isPortrait)
                ? const Alignment(0.0, 0.8)
                : (isLandscapeLeft ? const Alignment(-0.85, 0.0) : const Alignment(0.85, 0.0)),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInExpo,

            child: AnimatedOpacity(
              // Visibile solo in modalità lineare
              opacity: flatMode ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),

              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: transitionBuilder,
                // Switch tra info card normale e ruotata
                child: isPortrait
                    ? _buildInfoCard(
                    "${AppLocalizations.of(context)!.translate('Inclinazione')} (${isPortrait ? 'X' : 'Y'})",
                    angle,
                    key: const ValueKey("info_port"))
                    : RotatedBox(
                  quarterTurns: textTurns,
                  child: _buildInfoCard(
                      "Inclinazione (${isPortrait ? 'X' : 'Y'})",
                      angle,
                      key: const ValueKey("info_land")),
                ),
              ),
            ),
          ),

          // 4. INFO CARDS TORICHE
          AnimatedAlign(
            // Posizione: sempre in basso
            alignment: const Alignment(0.0, 0.85),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInExpo,
            child: AnimatedOpacity(
              // Visibile solo in modalità piatta
              opacity: flatMode ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard("Roll (X)", _calculateDegrees(_x)),
                  _buildInfoCard("Pitch (Y)", _calculateDegrees(_y)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET FIALA ANIMATA (MORPHING)
  Widget _buildAnimatedLevelContainer(
      double width, double height, double borderRadius, Color onSurface,
      Alignment bubbleAlignment, bool isLevel, bool flatMode, bool isPortrait, Color borderColor
      ) {
    // AnimatedContainer gestisce il morphing della forma (width, height, radius)
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutBack,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor.withOpacity(0.5),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10)
        ],
      ),
      child: Stack(
        children: [
          // 1. Elementi torica (Cerchi esterni e Croci) - svaniscono in modalità lineare
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: flatMode ? 1.0 : 0.0,
            child: Stack(
              children: [
                // Cerchio grande esterno (solo decorativo per torica)
                Center(child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: borderColor.withOpacity(0.1), width: 1)))),
                // Croci
                Center(child: Container(width: 280, height: 1, color: borderColor.withOpacity(0.1))),
                Center(child: Container(width: 1, height: 280, color: borderColor.withOpacity(0.1))),
              ],
            ),
          ),

          // 2. BERSAGLIO CENTRALE (FISSO e SEMPRE VISIBILE)
          Center(
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: borderColor.withOpacity(0.5),
                          width: 2
                      )
                  )
              )
          ),

          // 3. LA BOLLA (Elemento comune)
          AnimatedAlign(
            duration: const Duration(milliseconds: 100),
            alignment: bubbleAlignment,
            child: Container(
              width: flatMode ? 40 : 50,
              height: flatMode ? 40 : 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBubbleColor(isLevel),
                boxShadow: [
                  BoxShadow(
                    color: _getBubbleColor(isLevel).withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Titolo
  Widget _buildModeTitle(String title, {Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  // Widget Info Card
  Widget _buildInfoCard(String title, double value, {Key? key}) {
    bool isOk = value.abs() < 1.0;
    return Card(
      key: key,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Importante per non espandersi troppo nello Stack
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 1),
            Text(
              "${value.toStringAsFixed(1)}°",
              style: TextStyle(
                fontSize: 24,
                color: isOk ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}