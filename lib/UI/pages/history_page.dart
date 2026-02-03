import 'package:flutter/material.dart';
import '../../model/managers/database_manager.dart';
import '../../model/objects/measurement.dart';
import '../../model/support/app_localizations.dart';
import 'package:intl/intl.dart'; // Per formattare la data

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Measurement>> _measurementsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _measurementsFuture = DatabaseManager().getAllMeasurements();
    });
  }

  // Funzione per cancellare un elemento
  void _deleteItem(int id) async {
    await DatabaseManager().deleteMeasurement(id);
    _loadData(); // Ricarica la lista dopo la cancellazione
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            AppLocalizations.of(context)!.translate('misura_eliminata')
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('cronologia_misure'),
        ),
      ),

      body: FutureBuilder<List<Measurement>>(
        future: _measurementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            String errorLabel = AppLocalizations.of(context)!.translate('errore_label');
            return Center(child: Text("$errorLabel: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.translate('no_saved_measurement')),
                ],
              ),
            );
          }

          final measurements = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final item = measurements[index];
              final dateStr = DateFormat('dd/mm/yyyy hh:mm').format(item.date);

              String dataLabel = AppLocalizations.of(context)!.translate('data_label');
              String rollLabel = AppLocalizations.of(context)!.translate('roll') ;
              String pitchLabel = AppLocalizations.of(context)!.translate('pitch') ;
              String tiltLabel = AppLocalizations.of(context)!.translate('Inclinazione');
              String gpsLabel = AppLocalizations.of(context)!.translate('gps_label');

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      item.type == 'Piatto' ? Icons.radio_button_checked : Icons.crop_portrait,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    item.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("$dataLabel: $dateStr", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      if (item.type == 'Piatto')
                        Text("$rollLabel: ${item.x.toStringAsFixed(1)}° | $pitchLabel: ${item.y.toStringAsFixed(1)}°")
                      else
                        Text("$tiltLabel: ${item.angle.toStringAsFixed(1)}°"),

                      if (item.latitude != null && item.longitude != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              "$gpsLabel: ${item.latitude!.toStringAsFixed(4)}°, ${item.longitude!.toStringAsFixed(4)}°",
                              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _deleteItem(item.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}