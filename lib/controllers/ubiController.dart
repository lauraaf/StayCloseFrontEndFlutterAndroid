import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class UbiController extends GetxController {
  final ubiService = UbiService();
  var ubis = <UbiModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;


  // Controladors per al formulari de creació i edició
  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController comentariController = TextEditingController();
  TextEditingController horariController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUbis();
  }

  //Obtenir totes les ubicacions
  Future<void> fetchUbis() async {
    isLoading.value = true;
    try {
      final fetchedUbis = await ubiService.getUbis();
      ubis.value = fetchedUbis;
    } catch (e) {
      errorMessage.value = 'Error al carregar les ubicacions.';
    } finally {
      isLoading.value = false;
    }
  }

  //Crear una nova ubicació
  Future<void> createUbi() async {
    final name = nameController.text.trim();
    final latitud = latitudeController.text.trim();
    final longitud = longitudeController.text.trim();
    final address = addressController.text.trim();
    final comentari = comentariController.text.trim();
    final tipo = tipoController.text.trim();
    final horari = horariController.text.trim();

  
    if (name.isEmpty || latitud.isEmpty || longitud.isEmpty || address.isEmpty || comentari.isEmpty  || tipo.isEmpty || horari.isEmpty) {
      Get.snackbar("Error", "Tots els camps són obligatoris");
      return;
    }

    try {
      isLoading.value = true;

      final ubication = {
        'latitud': double.parse(latitud),
        'longitud': double.parse(longitud),
      };
        
      await ubiService.createUbi(UbiModel(
        name: name,
        horari: horari,
        tipo: tipo,
        ubication: ubication,
        address: address,
        comentari: comentari,
      ));

      fetchUbis(); // Refresca la llista d'ubicacions
      clearForm();
      Get.snackbar("Èxit", "Ubicació creada correctament");
    
    } catch (e) {
      Get.snackbar("Error", "No s'ha pogut crear la ubicació");
    } finally {
      isLoading.value = false;
    }
  }

  // Editar una ubicació existent
  Future<void> editUbi(String id) async {
    final name = nameController.text.trim();
    final latitude = latitudeController.text.trim();
    final longitude = longitudeController.text.trim();
    final address = addressController.text.trim();
    final comentari = comentariController.text.trim();
    final tipo = tipoController.text.trim();
    final horari = horariController.text.trim();

    if (name.isEmpty || latitude.isEmpty || longitude.isEmpty || address.isEmpty || comentari.isEmpty  || tipo.isEmpty || horari.isEmpty) {
      Get.snackbar("Error", "Tots els camps són obligatoris");
      return;
    }

    try {
      isLoading.value = true;

      final ubication = {
        'latitude': double.parse(latitude),
        'longitude': double.parse(longitude),
      };

      await ubiService.editUbi(UbiModel(
        name: name,
        horari: horari,
        tipo: tipo,
        address: address,
        ubication: ubication,
        comentari: comentari,
      ), id);
      fetchUbis(); // Refresca la llista d'ubicacions
      clearForm();
      Get.snackbar("Èxit", "Ubicació editada correctament");
    } catch (e) {
      Get.snackbar("Error", "No s'ha pogut editar la ubicació");
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar una ubicació
  Future<void> deleteUbi(String id) async {
    try {
      isLoading.value = true;
      await ubiService.deleteUbiById(id);
      fetchUbis(); // Refresca la llista d'ubicacions
      Get.snackbar("Èxit", "Ubicació eliminada correctament");
    } catch (e) {
      Get.snackbar("Error", "No s'ha pogut eliminar la ubicació");
    } finally {
      isLoading.value = false;
    }
  }

// Filtrar ubicacions properes
  Future<void> filterNearbyLocations(double userLat, double userLon) async {
    isLoading.value = true;
    try {
      // Obtener todas las ubicaciones desde el servicio
      final allUbis = await ubiService.getUbis();

      // Filtrar las ubicaciones que estén a menos de 30 km
      const double radiusKm = 1.0;
      ubis.value = allUbis.where((ubi) {
        final lat = ubi.ubication['latitud'];
        final lon = ubi.ubication['longitud'];

        if (lat == null || lon == null) return false;

        return _calculateDistance(userLat, userLon, lat, lon) <= radiusKm;
      }).toList();
    } catch (e) {
      errorMessage.value = 'Error al filtrar les ubicacions.';
    } finally {
      isLoading.value = false;
    }
  }

  // Calcular la distancia entre dos coordenadas en kilómetros
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radio de la Tierra en kilómetros
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // Convertir grados a radianes
  double _degToRad(double deg) => deg * (pi / 180);



  // Netejar els camps del formulari
  void clearForm() {
    nameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    addressController.clear();
    comentariController.clear();
    tipoController.clear();
    horariController.clear();

  }

}