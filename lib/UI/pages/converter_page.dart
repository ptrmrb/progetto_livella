import 'package:flutter/material.dart';
import '../../model/support/app_localizations.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  // Controller per il campo di testo
  final TextEditingController _inputController = TextEditingController();

  // Stato per le selezioni
  String _selectedCategory = 'Lunghezza';
  String _fromUnit = 'Metri';
  String _toUnit = 'Piedi';
  double _inputValue = 0.0;
  double _resultValue = 0.0;

  // Definizioni delle unità per ogni categoria
  // (In un'app reale, questo andrebbe in un file Model separato)
  final Map<String, List<String>> _units = {
    'Lunghezza': ['Metri', 'Chilometri', 'Piedi', 'Miglia', 'Pollici'],
    'Peso': ['Chilogrammi', 'Grammi', 'Libbre', 'Once'],
    'Temperatura': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  @override
  void initState() {
    super.initState();
    // Aggiungiamo un listener per aggiornare il calcolo mentre si scrive
    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {
      // Se il campo è vuoto o non valido, usiamo 0.0
      _inputValue = double.tryParse(_inputController.text) ?? 0.0;
      _calculateResult();
    });
  }

  // Logica di Conversione Semplificata
  void _calculateResult() {

    if (_selectedCategory == 'Lunghezza') {
      _resultValue = _convertLength(_inputValue, _fromUnit, _toUnit);
    } else if (_selectedCategory == 'Peso') {
      _resultValue = _convertWeight(_inputValue, _fromUnit, _toUnit);
    } else if (_selectedCategory == 'Temperatura') {
      _resultValue = _convertTemperature(_inputValue, _fromUnit, _toUnit);
    }
  }

  // Funzione di conversione per la Lunghezza
  double _convertLength(double value, String from, String to) {
    // 1. Converti tutto in Metri (unità base)
    double inMeters;
    switch (from) {
      case 'Chilometri': inMeters = value * 1000; break;
      case 'Piedi': inMeters = value / 3.28084; break;
      case 'Miglia': inMeters = value * 1609.34; break;
      case 'Pollici': inMeters = value / 39.3701; break;
      default: inMeters = value; // Metri
    }

    // 2. Converti da Metri all'unità target
    switch (to) {
      case 'Chilometri': return inMeters / 1000;
      case 'Piedi': return inMeters * 3.28084;
      case 'Miglia': return inMeters / 1609.34;
      case 'Pollici': return inMeters * 39.3701;
      default: return inMeters; // Metri
    }
  }

  // Funzione di conversione Peso
  double _convertWeight(double value, String from, String to) {
    double inKg;
    switch (from) {
      case 'Grammi': inKg = value / 1000; break;
      case 'Libbre': inKg = value * 0.453592; break;
      case 'Once': inKg = value * 0.0283495; break;
      default: inKg = value; // Chilogrammi
    }

    switch (to) {
      case 'Grammi': return inKg * 1000;
      case 'Libbre': return inKg / 0.453592;
      case 'Once': return inKg / 0.0283495;
      default: return inKg; // Chilogrammi
    }
  }

  // Funzione di conversione Temperatura
  double _convertTemperature(double value, String from, String to) {
    double inCelsius;
    switch (from) {
      case 'Fahrenheit': inCelsius = (value - 32) * 5 / 9; break;
      case 'Kelvin': inCelsius = value - 273.15; break;
      default: inCelsius = value; // Celsius
    }

    switch (to) {
      case 'Fahrenheit': return (inCelsius * 9 / 5) + 32;
      case 'Kelvin': return inCelsius + 273.15;
      default: return inCelsius; // Celsius
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('convertitore'),
        ),
      ),

      // Usiamo GestureDetector per chiudere la tastiera toccando fuori
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Selettore Categoria
              _buildCategorySelector(colorScheme),

              const SizedBox(height: 30),

              // Cart Input
              _buildInputCard(colorScheme),

              const SizedBox(height: 20),

              // Icona per scambiare le unità
              Center(
                child: IconButton(
                  icon: Icon(Icons.swap_vert_circle, size: 40, color: colorScheme.primary),
                  onPressed: () {
                    // Scambia le unità
                    setState(() {
                      final temp = _fromUnit;
                      _fromUnit = _toUnit;
                      _toUnit = temp;
                      _calculateResult();
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Card Output
              _buildOutputCard(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  // Builder Selettore Categoria
  Widget _buildCategorySelector(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: Icon(Icons.category, color: colorScheme.primary),
          items: _units.keys.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                AppLocalizations.of(context)!.translate(category.toLowerCase()),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
                // Resetta le unità alla prima della nuova categoria
                _fromUnit = _units[newValue]![0];
                _toUnit = _units[newValue]![1];
                _calculateResult();
              });
            }
          },
        ),
      ),
    );
  }

  // Card Input
  Widget _buildInputCard(ColorScheme colorScheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context)!.translate('da'),
                style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Campo di testo
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _inputController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "0.0",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Tendina dropdown unità di partensza
                Expanded(
                  flex: 1,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _fromUnit,
                      isExpanded: true,
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                      items: _units[_selectedCategory]!.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(
                            // Traduzione unità
                              AppLocalizations.of(context)!.translate(unit.toLowerCase())
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _fromUnit = newValue!;
                          _calculateResult();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card Output
  Widget _buildOutputCard(ColorScheme colorScheme) {
    return Card(
      elevation: 4,
      color: colorScheme.primaryContainer, // Sfondo colorato per evidenziare il risultato
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context)!.translate('a'),
                style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Testo Risultato
                Expanded(
                  flex: 2,
                  child: Text(
                    // Mostriamo fino a 4 decimali e rimuoviamo gli zeri inutili
                    _resultValue.toStringAsFixed(4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 10),

                // Altra tendina Dropdown unità destinazione
                Expanded(
                  flex: 1,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _toUnit,
                      isExpanded: true,
                      dropdownColor: colorScheme.primaryContainer,
                      style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down, color: colorScheme.onPrimaryContainer),
                      items: _units[_selectedCategory]!.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(
                              AppLocalizations.of(context)!.translate(unit.toLowerCase())
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _toUnit = newValue!;
                          _calculateResult();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}