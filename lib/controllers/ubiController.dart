import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';
import 'package:geocoding/geocoding.dart'; // Paquete para geocodificación
import 'package:http/http.dart' as http; // Para hacer la solicitud HTTP
import 'dart:convert'; 



class UbiController extends GetxController {
  final ubiService = UbiService();
  var ubis = <UbiModel>[].obs;
  var nearbyUbisNames = <String>[].obs; // Lista solo de los nombres de las ubicaciones cercanas
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Controladores para el formulario de creación y edición
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController comentariController = TextEditingController();
  TextEditingController horariController = TextEditingController();
  var selectedUbi = Rx<UbiModel?>(null); // Ubicación seleccionada (reactiva)

  var latitude;
  var longitude;

  @override
  void onInit() {
    super.onInit();
    fetchUbis();
  }

  // Obtener todas las ubicaciones
  Future<void> fetchUbis() async {
    isLoading.value = true;
    try {
      final fetchedUbis = await ubiService.getUbis();
      ubis.value = fetchedUbis;
    } catch (e) {
      errorMessage.value = 'Error al cargar las ubicaciones.';
    } finally {
      isLoading.value = false;
    }
  }
// Método para crear una nueva ubicación
  Future<void> createUbi() async {
    isLoading.value = true;
    try {
      final address = addressController.text.trim();

      if (address.isEmpty) {
        Get.snackbar("Error", "La dirección no puede estar vacía.");
        isLoading.value = false;
        return;
      }

      // Hacer la solicitud de geocodificación para obtener las coordenadas
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);

          // Crear el objeto Ubication
          final ubication = Ubication(
            type: 'Point',  // El tipo de la ubicación, que normalmente será "Point" para coordenadas
            coordinates: [lon, lat], // La longitud y latitud
          );

          print("longitud: $lon, latitud: $lat");

          // Crear la ubicación (UbiModel)
          final newUbi = UbiModel(
            name: nameController.text.trim(),
            tipo: tipoController.text.trim(),
            horari: horariController.text.trim(),
            ubication: ubication,  // Usamos la instancia de Ubication aquí
            address: address,
            comentari: comentariController.text.trim(),
          );

          // Llamada al servicio para crear la nueva ubicación
          await ubiService.createUbi(newUbi);

          // Refrescar las ubicaciones y limpiar el formulario
          fetchUbis();
          clearForm();
          Get.snackbar("Éxito", "Ubicación creada correctamente.");
        } else {
          Get.snackbar("Error", "Dirección no encontrada.");
        }
      } else {
        Get.snackbar("Error", "Error al geocodificar la dirección.");
      }
    } catch (e) {
      Get.snackbar("Error", "Hubo un error al crear la ubicación.");
    } finally {
      isLoading.value = false;
    }
  }
  // Eliminar una ubicación
  Future<void> deleteUbi(String id) async {
    try {
      isLoading.value = true;
      await ubiService.deleteUbiById(id);
      fetchUbis(); // Refresca la lista de ubicaciones
      Get.snackbar("Éxito", "Ubicación eliminada correctamente");
    } catch (e) {
      Get.snackbar("Error", "No se ha podido eliminar la ubicación");
    } finally {
      isLoading.value = false;
    }
  }

  // Limpiar los campos del formulario
  void clearForm() {
    nameController.clear();
    addressController.clear();
    comentariController.clear();
    tipoController.clear();
    horariController.clear();
  }

  // Método para seleccionar una ubicación y actualizar selectedUbi
  void selectUbi(UbiModel ubi) {
    selectedUbi.value = ubi; // Actualiza la ubicación seleccionada
  }

  // Limpiar la ubicación seleccionada
  void clearSelectedUbi() {
    selectedUbi.value = null;
  }
}
