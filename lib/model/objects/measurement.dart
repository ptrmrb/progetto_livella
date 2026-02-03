class Measurement { // Rappresenta una singola misurazione salvata in app
  int? id; // ID univoco (null se non ancora salvato)
  final String type; // "Piatto" o "Lineare"
  final double x; // Roll / Inclinazione X
  final double y; // Pitch / Inclinazione Y
  final double angle; // Angolo calcolato (per lineare)
  final int timestamp; // Data in millisecondi
  final String description; // Descrizione utente
  final double? latitude;
  final double? longitude;

  Measurement({
    this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.angle,
    required this.timestamp,
    required this.description,
    this.latitude,
    this.longitude,
  });

  // Converte un oggetto Measurement in una Map (per inserirlo nel DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'x': x,
      'y': y,
      'angle': angle,
      'timestamp': timestamp,
      'description': description,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  // Crea un oggetto Measurement partendo da una Map (letta dal DB)
  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'],
      type: map['type'],
      x: map['x'],
      y: map['y'],
      angle: map['angle'],
      timestamp: map['timestamp'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude']
    );
  }

  // Helper per ottenere la data leggibile
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);
}