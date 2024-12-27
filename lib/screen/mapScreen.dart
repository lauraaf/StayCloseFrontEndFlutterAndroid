import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/widgets/ubiCard.dart'; // Asegúrate de importar UbiCard

class MapScreen extends StatelessWidget {
  final UbiController ubiController = Get.put(UbiController());
  RxList<UbiModel> selectedUbications = RxList<UbiModel>([]);

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

        return Stack(
          children: [
            // Mapa
            FlutterMap(
              options: MapOptions(
                center: LatLng(41.382395521312176, 2.1567611541534366),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: ubiController.ubis.map((ubi) {
                    final latitude = ubi.ubication.latitud ?? 41.382395521312176;
                    final longitude = ubi.ubication.longitud ?? 2.1567611541534366;

                    return Marker(
                      point: LatLng(latitude, longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          if (!selectedUbications.contains(ubi)) {
                            selectedUbications.add(ubi);
                          }
                        },
                        child: const Icon(
                          Icons.place,
                          color: Color.fromARGB(255, 133, 160, 160),
                          size: 35.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Cuadro de búsqueda en la esquina superior derecha
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(121, 178, 213, 213),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 92, 165, 165), // El color del borde
                    width: 2.0, // El grosor del borde
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar ubicacions per distància',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitud',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitud',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.distanceController,
                      decoration: const InputDecoration(
                        labelText: 'Distància (en metres)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          double latitude = double.parse(ubiController.latitudeController.text);
                          double longitude = double.parse(ubiController.longitudeController.text);
                          double distance = double.parse(ubiController.distanceController.text);

                          // Llamamos a la función para obtener las ubicaciones cercanas
                          await ubiController.getNearbyUbis(latitude, longitude, distance);
                        } catch (e) {
                          Get.snackbar("Error", "Por favor, ingresa valores válidos.");
                        }
                      },
                      child: const Text('Buscar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89AFAF),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mostrar tarjetas debajo del buscador
            Positioned(
              top: 250,
              left: 16,
              right: 16,
              child: Column(
                children: selectedUbications.map((ubi) {
                  return UbiCard(ubi: ubi); // Usamos el widget UbiCard aquí
                }).toList(),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUbiDialog(context);
        },
        backgroundColor: const Color(0xFF89AFAF),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUbiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Nova Ubicació',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89AFAF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: ubiController.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.addressController,
                    decoration: const InputDecoration(
                      labelText: 'Adreça',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.horariController,
                    decoration: const InputDecoration(
                      labelText: 'Horari',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.tipoController,
                    decoration: const InputDecoration(
                      labelText: 'Tipus',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.comentariController,
                    decoration: const InputDecoration(
                      labelText: 'Comentari',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitud',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitud',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await ubiController.createUbi();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89AFAF),
                      ),
                      child: const Text('Crear Ubicació'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
