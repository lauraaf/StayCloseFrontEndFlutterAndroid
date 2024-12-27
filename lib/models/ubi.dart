class UbiModel {
  final String name;
  final String horari;
  final String tipo;
  final Ubication ubication;
  final String address;
  final String comentari;

  UbiModel({
    required this.name,
    required this.horari,
    required this.tipo,
    required this.ubication,
    required this.address,
    required this.comentari,
  });

  // Método para crear una instancia de UbiModel desde JSON
  factory UbiModel.fromJson(Map<String, dynamic> json) {
    return UbiModel(
      name: json['name'] ?? '',
      horari: json['horari'] ?? '',
      tipo: json['tipo'] ?? '',
      ubication: Ubication.fromJson(json['ubication'] ?? {}),
      address: json['address'] ?? '',
      comentari: json['comentari'] ?? '',
    );
  }

  // Método toJson para enviar los datos al backend
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'horari': horari,
      'tipo': tipo,
      'ubication': ubication.toJson(),
      'address': address,
      'comentari': comentari,
    };
  }
}

// Clase para manejar la ubicación (ubication)
class Ubication {
  final String type;
  final List<double> coordinates;

  Ubication({
    required this.type,
    required this.coordinates,
  });

  // Getter para obtener la latitud
  double get latitud => coordinates.isNotEmpty ? coordinates[1] : 0.0;

  // Getter para obtener la longitud
  double get longitud => coordinates.isNotEmpty ? coordinates[0] : 0.0;

  // Método para crear una instancia de Ubication desde JSON
  factory Ubication.fromJson(Map<String, dynamic> json) {
    return Ubication(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((coord) => coord is num ? coord.toDouble() : 0.0)
          .toList(),
    );
  }

  // Método toJson para enviar los datos de ubicación al backend
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
