import 'package:flutter/foundation.dart';

class Vivencia {
  final int? id; // SQLite genera un id automáticamente
  final String titulo;
  final DateTime fecha;
  final String descripcion;
  final String? fotoPath; // Opcional, puede no tener foto
  final String? audioPath; // Opcional, puede no tener audio

  Vivencia({
    this.id,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    this.fotoPath,
    this.audioPath,
  });

  // Convertir un objeto Vivencia en un Map. Útil para insertar datos en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'fotoPath': fotoPath,
      'audioPath': audioPath,
    };
  }

  // Crear un objeto Vivencia desde un Map. Útil para leer datos de la base de datos
  factory Vivencia.fromMap(Map<String, dynamic> map) {
    return Vivencia(
      id: map['id'],
      titulo: map['titulo'],
      fecha: DateTime.parse(map['fecha']),
      descripcion: map['descripcion'],
      fotoPath: map['fotoPath'],
      audioPath: map['audioPath'],
    );
  }
}
