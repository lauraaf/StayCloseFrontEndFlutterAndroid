import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart'; // UbiController para manejar las ubicaciones
import 'package:flutter_application_1/controllers/ubiListController.dart'; // UbiListController para manejar la lista de ubicaciones seleccionadas
import 'package:flutter_application_1/widgets/ubiCard.dart'; // Asegúrate de importar UbiCard

class MapScreen extends StatelessWidget {
  final UbiController ubiController = Get.put(UbiController()); // UbiController para manejar las ubicaciones
  final UbiListController ubiListController = Get.put(UbiListController()); // UbiListController para manejar la lista de ubicaciones seleccionadas

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
                  markers: ubiController.ubis.map((ubi) {
                    final latitude = ubi.ubication.latitud ?? 41.382395521312176;
                    final longitude = ubi.ubication.longitud ?? 2.1567611541534366;

                    return Marker(
                      point: LatLng(latitude, longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Actualiza la ubicación seleccionada en el UbiController
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
                    color: const Color.fromARGB(255, 92, 165, 165),
                    width: 2.0,
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
                        labelText: 'Distància (en km)',
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
                          await ubiListController.getNearbyUbis(latitude, longitude, distance);
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
