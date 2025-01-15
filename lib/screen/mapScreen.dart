import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart';
import 'package:flutter_application_1/controllers/ubiListController.dart';
import 'package:flutter_application_1/widgets/ubiCard.dart';
import 'package:geolocator/geolocator.dart'; // Paquete para geolocalización

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final UbiController ubiController = Get.put(UbiController());
  final UbiListController ubiListController = Get.put(UbiListController());

  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Obtener la ubicación del usuario al entrar al mapa
  }

  // Función para obtener la ubicación del usuario
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Los servicios de ubicación no están habilitados.");
      return;
    }

    // Verificar si se tiene permiso para acceder a la ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permiso de ubicación denegado.");
        return;
      }
    }

    // Obtener la ubicación actual del usuario
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });

      // Llamamos a la función para obtener las ubicaciones cercanas
      if (userLatitude != null && userLongitude != null) {
        await ubiListController.getNearbyUbis(userLatitude!, userLongitude!, 10); // Buscar ubicaciones cercanas a 10 km de distancia
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'.tr), // Traducción dinámica
        backgroundColor: Color(0xFF89AFAF),
        actions: [
          // Botón para cambio de idioma
          PopupMenuButton<String>( // Menú para cambio de idioma
            onSelected: (String languageCode) {
              if (languageCode == 'ca') {
                Get.updateLocale(Locale('ca', 'ES'));
              } else if (languageCode == 'es') {
                Get.updateLocale(Locale('es', 'ES'));
              } else if (languageCode == 'en') {
                Get.updateLocale(Locale('en', 'US'));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'ca', child: Text('Català')),
                PopupMenuItem(value: 'es', child: Text('Español')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ];
            },
          ),
        ],
      ),
      body: Obx(() {
        if (ubiController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (ubiController.ubis.isEmpty) {
          return Center(child: Text('No hay ubicaciones disponibles'.tr));
        }

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: userLatitude != null && userLongitude != null
                    ? LatLng(userLatitude!, userLongitude!)
                    : LatLng(41.382395521312176, 2.1567611541534366),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // Marcador de la ubicación del usuario (en rojo)
                    if (userLatitude != null && userLongitude != null)
                      Marker(
                        point: LatLng(userLatitude!, userLongitude!),
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Colors.red, // Color rojo para la ubicación del usuario
                          size: 38.0,
                        ),
                      ),
                    // Otros marcadores para las ubicaciones
                    ...ubiController.ubis.map((ubi) {
                      final latitude = ubi.ubication.latitud ?? 41.382395521312176;
                      final longitude = ubi.ubication.longitud ?? 2.1567611541534366;

                      return Marker(
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => GestureDetector(
                          onTap: () {
                            ubiController.selectUbi(ubi);
                          },
                          child: const Icon(
                            Icons.place,
                            color: Color.fromARGB(255, 84, 91, 111),
                            size: 38.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),

            // Elementos adicionales, como el título y las ubicaciones cercanas
            Positioned(
              top: 8, 
              right: 27, 
              child: Container(
                width: 290, 
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(191, 255, 255, 255), 
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Color.fromARGB(255, 84, 91, 111), width: 1.5), 
                ),
                child: Center(
                  child: Text(
                    'Punts propers a tú',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 84, 91, 111),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 58,
              right: 10,
              child: Container(
                width: 320, 
                height: 450, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                          controller: ubiListController.scrollController,
                          itemCount: ubiListController.ubis.length + 1,
                          itemBuilder: (context, index) {
                            if (index == ubiListController.ubis.length) {
                              return ubiListController.isLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            } else {
                              var ubi = ubiListController.ubis[index];
                              return UbiCard(ubi: ubi);
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUbiDialog(context);
        },
        backgroundColor: Color(0xFF89AFAF),
        child: Icon(Icons.add),
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
                      labelText: 'Adreça (carrer, localitat)',
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
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        //ubiController.getCoordinatesFromAddress(ubiController.addressController.text);
                        await ubiController.createUbi();  // Llamar a la función de creación
                        Navigator.of(context).pop();  // Cerrar el diálogo después de crear
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
