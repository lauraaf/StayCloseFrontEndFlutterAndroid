import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/controllers/ubiController.dart';
import 'package:flutter_application_1/controllers/ubiListController.dart';
import 'package:flutter_application_1/widgets/ubiCard.dart';

class MapScreen extends StatelessWidget {
  final UbiController ubiController = Get.put(UbiController());
  final UbiListController ubiListController = Get.put(UbiListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'.tr), // Traducción dinámica
        backgroundColor: Color(0xFF89AFAF),
        actions: [
          // Botón para cambio de idioma
          PopupMenuButton<String>(
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
                    final longitude = ubi.ubication.longitud ?? 2.1567611541534366; // Corregido a 'longitud'

                    return Marker(
                      point: LatLng(latitude, longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Actualiza la ubicacion seleccionada en el UbiController
                          ubiController.selectUbi(ubi);
                        },
                        child: Icon(
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
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(121, 178, 213, 213),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color.fromARGB(255, 92, 165, 165),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buscar ubicaciones por distancia'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.latitudeController,
                      decoration: InputDecoration(
                        labelText: 'Latitud'.tr,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Longitud'.tr,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ubiController.distanceController,
                      decoration: InputDecoration(
                        labelText: 'Distancia (en km)'.tr,
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
                          Get.snackbar("Error", "Por favor, ingresa valores válidos.".tr);
                        }
                      },
                      child: Text('Buscar'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF89AFAF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 310,
              right: 20,
              child: Container(
                width: 300,
                height: 400,
                child: Obx(() {
                  return ListView.builder(
                    controller: ubiListController.scrollController,
                    itemCount: ubiListController.ubis.length + 1, // Añadimos uno para mostrar el indicador de carga
                    itemBuilder: (context, index) {
                      if (index == ubiListController.ubis.length) {
                        // Si hemos llegado al final, mostramos un indicador de carga
                        return ubiListController.isLoading.value
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : SizedBox.shrink();
                      } else {
                        var ubi = ubiListController.ubis[index];
                        return UbiCard(ubi: ubi);
                      }
                    },
                  );
                }),
              ),
            ),
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                  Center(
                    child: Text(
                      'Nueva Ubicación'.tr,
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
                    decoration: InputDecoration(
                      labelText: 'Nombre'.tr,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.addressController,
                    decoration: InputDecoration(
                      labelText: 'Dirección'.tr,
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Latitud'.tr,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubiController.longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitud'.tr,
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
                        backgroundColor: Color(0xFF89AFAF),
                      ),
                      child: Text('Crear Ubicación'.tr),
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
