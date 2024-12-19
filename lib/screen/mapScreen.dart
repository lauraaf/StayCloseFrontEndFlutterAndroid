import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart';
import 'package:flutter_application_1/models/ubi.dart';

class MapScreen extends StatelessWidget {
  final UbiController ubiController = Get.put(UbiController());
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: const Color(0xFF89AFAF),
      ),
      body: Obx(() {
        if (ubiController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ubiController.ubis.isEmpty) {
          return const Center(child: Text('No hi ha ubicacions disponibles'));
        }

        return Row(
          children: [
            // Mapa a la izquierda
            Expanded(
              flex: 2,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(41.382395521312176, 2.1567611541534366),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: ubiController.ubis.map((ubi) {
                      final latitude =
                          ubi.ubication['latitud'] ?? 41.382395521312176;
                      final longitude =
                          ubi.ubication['longitud'] ?? 2.1567611541534366;

                      return Marker(
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => Icon(
                          Icons.place,
                          color: const Color.fromARGB(255, 133, 160, 160),
                          size: 35.0,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Lista de ubicaciones a la derecha
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Input para latitud y longitud
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: latitudeController,
                              decoration: const InputDecoration(
                                labelText: 'Latitud',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: longitudeController,
                              decoration: const InputDecoration(
                                labelText: 'Longitud',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final lat = double.tryParse(latitudeController.text);
                              final lon = double.tryParse(longitudeController.text);

                              if (lat == null || lon == null) {
                                Get.snackbar('Error', 'Introduce coordenadas válidas.');
                                return;
                              }

                              ubiController.filterNearbyLocations(lat, lon);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF89AFAF),
                            ),
                            child: const Text('Buscar'),
                          ),
                        ],
                      ),
                    ),
                    // Lista de ubicaciones filtradas
                    Expanded(
                      child: ListView.builder(
                        itemCount: ubiController.ubis.length,
                        itemBuilder: (context, index) {
                          final ubi = ubiController.ubis[index];
                          return ListTile(
                            title: Text(ubi.name),
                            subtitle: Text(ubi.address),
                            trailing: Icon(Icons.location_on),
                            onTap: () {
                              // Lógica para manejar la selección de una ubicación
                              Get.snackbar("Ubicación seleccionada", ubi.name);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
