import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UbiController extends GetxController {
  final ubiService = UbiService();
  var ubis = <UbiModel>[].obs;
  var nearbyUbisNames = <String>[].obs; // Lista solo de los nombres de las ubicaciones cercanas
  var isLoading = false.obs;
  var errorMessage = ''.obs;


  // Controladors per al formulari de creació i edició
  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController distanceController = TextEditingController(); // Para la distancia
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

  // Buscar ubicaciones cercanas y solo obtener sus nombres
  Future<void> getNearbyUbis(double lat, double lon, double distance) async {
    isLoading.value = true;
    try {
      // Realizamos la consulta de ubicaciones cercanas a través del servicio
      final nearbyUbis = await ubiService.getNearbyUbis(lat, lon, distance);
      
      // Extraemos solo los nombres de las ubicaciones cercanas
      nearbyUbisNames.value = nearbyUbis.map((ubi) => ubi.name).toList();

      print("Ubicaciones cercanas encontradas: ${nearbyUbisNames.value}");
    } catch (e) {
      errorMessage.value = 'Error al obtener las ubicaciones cercanas';
      print('Error al obtener ubicaciones cercanas: $e');
    } finally {
      isLoading.value = false;
    }
  }

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