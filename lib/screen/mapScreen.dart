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
  String selectedType = 'Todos';
  
  double? userLatitude;
  double? userLongitude;

  double? homeLatitude;
  double? homeLongitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Obtener la ubicación del usuario al entrar al mapa
    _loadHomeLocation();
  }

  // Funció per obtenir la ubicació de la casa de l'usuari
  Future<void> _loadHomeLocation() async {
    try {
      final coordinates = await ubiController.loadUserAddress();

      homeLatitude = coordinates['latitude'];
      homeLongitude = coordinates['longitude'];

      setState(() {});
      print('Ubicació de la casa: Lat: $homeLatitude, Lon: $homeLongitude');
    } catch (e) {
      print('Error al obtenir la ubicació de la casa: $e');
    }
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


// Funció per filtrar ubicacions segons tipus
void _filterLocationsByType(String type) {
  print("Arribo aqui amb el tipus: $type");
  setState(() {
    selectedType = type; // Actualitza la variable per filtrar
    if (type == 'Todos') {
      print("Es TODAS LAS ubi------");
      ubiController.fetchUbis(); // Mostra totes les ubicacions
    } else {
      print("Es otro tipo de ubi------");
      ubiController.fetchUbisByType(type); // Filtra les ubicacions segons el tipus seleccionat
    }
  });
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
          print("---------------------Aqui estan todas las ubicaciones impresas en el mapa");
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
                    // Marcador de la casa del usuario (en azul)
                    if (homeLatitude != null && homeLongitude != null)
                      Marker(
                        point: LatLng(homeLatitude!, homeLongitude!),
                        builder: (ctx) => const Icon(
                          Icons.home,
                          color: Color.fromARGB(255, 103, 158, 132), // Color azul para la casa
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

// Barra de filtros
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Punto lila', 'Hospital', 'Centro', 'Otro']
                    .map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      _filterLocationsByType(type);
                    },
                    child: Text(type.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == type
                          ? const Color(0xFF89AFAF)
                          : const Color.fromARGB(255, 178, 178, 178),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                    'Puntos cercanos a ti'.tr,
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
            // Card de la información de los puntos de ubicación
            Obx(() {
              final selectedUbi = ubiController.selectedUbi.value;
              if (selectedUbi != null) {
                return Positioned(
                  top: 7,
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
                                icon: Icon(Icons.close, color: Colors.red),
                                iconSize: 20,
                                onPressed: () {
                                  ubiController.selectedUbi.value = null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text('· Dirección: ${selectedUbi.address}'.tr),
                          SizedBox(height: 5),
                          Text('· Tipo: ${selectedUbi.tipo}'.tr),
                          SizedBox(height: 5),
                          Text('· Comentario: ${selectedUbi.comentari}'.tr),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            }),
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
                 // const Center(
                   Text(
                      'Nueva ubicación'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89AFAF),
                      ),
                    ),
                  //),
                  const SizedBox(height: 20),
                  TextField(
                    controller: ubiController.nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.addressController,
                    decoration: InputDecoration(
                      labelText: 'Dirección (calle, número de portería, localidad)'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.horariController,
                    decoration: InputDecoration(
                      labelText: 'Horario'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.tipoController,
                    decoration: InputDecoration(
                      labelText: 'Tipo'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.comentariController,
                    decoration: InputDecoration(
                      labelText: 'Comentario'.tr,
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
                      child: Text(
                        'Crear ubicación'.tr,
                         style: TextStyle(color: Colors.white), // Texto en blanco
                      ),
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
