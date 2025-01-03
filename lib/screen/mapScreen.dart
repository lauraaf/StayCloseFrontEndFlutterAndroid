import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart'; // UbiController para manejar las ubicaciones
import 'package:flutter_application_1/controllers/ubiListController.dart'; // UbiListController para manejar la lista de ubicaciones seleccionadas
import 'package:flutter_application_1/widgets/ubiCard.dart'; // Asegúrate de importar UbiCard
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
    print("Vamos a obtener la ubicacion del usuario");
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
    } else {
      print("Servicios de ubicación habilitados.");
    }

    // Verificar si se tiene permiso para acceder a la ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permiso de ubicación denegado.");
        return;
      } else {
        print("Permiso de ubicación concedido.");
      }
    } else {
      print("Permiso de ubicación ya concedido.");
    }

    // Obtener la ubicación actual del usuario
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Ubicación obtenida: Lat: ${position.latitude}, Lon: ${position.longitude}");

      // Actualizar el estado con las coordenadas obtenidas
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });

      // Llamamos a la función para obtener las ubicaciones cercanas
      if (userLatitude != null && userLongitude != null) {
        await ubiListController.getNearbyUbis(userLatitude!, userLongitude!, 10); // Buscar ubicaciones cercanas a 10 km de distancia
      }

      // Añadir el marcador en el mapa
      if (userLatitude != null && userLongitude != null) {
        final userMarker = Marker(
          point: LatLng(userLatitude!, userLongitude!),
          builder: (ctx) => const Icon(
            Icons.location_on,
            color: Colors.red, // Color rojo para la ubicación del usuario
            size: 38.0,
          ),
        );

        print("Marcador añadido en la ubicación del usuario.");
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: const Color(0xFF89AFAF),
      ),
      body: Obx(() {
        // Muestra un cargador mientras se obtienen las ubicaciones
        if (ubiController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si no hay ubicaciones, muestra un mensaje
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
                  markers: [
                    // Marcador de la ubicación del usuario (en rojo)
                    if (userLatitude != null && userLongitude != null)
                      Marker(
                        point: LatLng(userLatitude!, userLongitude!),
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Colors.red, // Color rojo para indicar la ubicación del usuario
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

            // Mostrar tarjetas debajo del mapa con las ubicaciones cercanas
            Positioned(
              top: 310,
              right: 20,
              child: Container(
                width: 300, // Ajusta el ancho según lo necesites
                height: 400, // Ajusta la altura según lo necesites
                child: Obx(() {
                  return ListView.builder(
                    controller: ubiListController.scrollController, // Asociamos el ScrollController
                    itemCount: ubiListController.ubis.length + 1, // Añadimos uno para mostrar el indicador de carga
                    itemBuilder: (context, index) {
                      if (index == ubiListController.ubis.length) {
                        // Si hemos llegado al final, mostramos un indicador de carga
                        return ubiListController.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      } else {
                        var ubi = ubiListController.ubis[index];
                        return UbiCard(ubi: ubi); // Mostrar las ubicaciones
                      }
                    },
                  );
                }),
              ),
            ),

            // Mostrar tarjeta de la ubicación seleccionada en la parte superior derecha
            Obx(() {
              final selectedUbi = ubiController.selectedUbi.value;
              if (selectedUbi != null) {
                return Positioned(
                  top: 16,
                  right: 323,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${selectedUbi.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                iconSize: 20, // Tamaño más pequeño para el ícono
                                onPressed: () {
                                  ubiController.selectedUbi.value = null; // Desmarcar la ubicación
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text('· Dirección: ${selectedUbi.address}'),
                          SizedBox(height: 5),
                          Text('· Tipo: ${selectedUbi.tipo}'),
                          SizedBox(height: 5),
                          Text('· Comentario: ${selectedUbi.comentari}'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container(); // Si no hay ubicación seleccionada, no mostramos la tarjeta
            }),
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
