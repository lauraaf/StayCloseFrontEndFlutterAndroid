import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';

class UbiController extends GetxController {
  final ubiService = UbiService();
  var ubis = <UbiModel>[].obs;
  var nearbyUbisNames = <String>[].obs; // Lista solo de los nombres de las ubicaciones cercanas
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Controladores para el formulario de creación y edición
  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController distanceController = TextEditingController(); // Para la distancia
  TextEditingController addressController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController comentariController = TextEditingController();
  TextEditingController horariController = TextEditingController();
  var selectedUbi = Rx<UbiModel?>(null); // Ubicación seleccionada (reactiva)


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

  // Crear una nueva ubicación
  Future<void> createUbi() async {
  final name = nameController.text.trim();
  final latitude = latitudeController.text.trim();
  final longitude = longitudeController.text.trim();
  final address = addressController.text.trim();
  final comentari = comentariController.text.trim();
  final tipo = tipoController.text.trim();
  final horari = horariController.text.trim();

  if (name.isEmpty || address.isEmpty || comentari.isEmpty || tipo.isEmpty || horari.isEmpty) {
    Get.snackbar("Error", "Tots els camps són obligatoris");
    return;
  }

  try {
    isLoading.value = true;

    // Si no se tiene latitud y longitud, ubication se deja vacío
    Ubication? ubication = (latitude.isNotEmpty && longitude.isNotEmpty)
        ? Ubication(
            type: "Point",
            coordinates: [double.parse(longitude), double.parse(latitude)],
          )
        : null;

    await ubiService.createUbi(UbiModel(
      name: name,
      horari: horari,
      tipo: tipo,
      ubication: ubication ?? Ubication(type: "Point", coordinates: []), // Enviar un objeto vacío si ubication es null
      address: address,
      comentari: comentari,
    ));

    fetchUbis(); // Refresca la lista de ubicaciones
    clearForm();
    Get.snackbar("Èxit", "Ubicació creada correctament");
  } catch (e) {
    Get.snackbar("Error", "No s'ha pogut crear la ubicació");
  } finally {
    isLoading.value = false;
  }
}

  // Editar una ubicación existente
  Future<void> editUbi(String id) async {
    final name = nameController.text.trim();
    final latitude = latitudeController.text.trim();
    final longitude = longitudeController.text.trim();
    final address = addressController.text.trim();
    final comentari = comentariController.text.trim();
    final tipo = tipoController.text.trim();
    final horari = horariController.text.trim();

    if (name.isEmpty || latitude.isEmpty || longitude.isEmpty || address.isEmpty || comentari.isEmpty || tipo.isEmpty || horari.isEmpty) {
      Get.snackbar("Error", "Tots els camps són obligatoris");
      return;
    }

    try {
      isLoading.value = true;

      final ubication = Ubication(
        type: "Point",
        coordinates: [double.parse(longitude), double.parse(latitude)],
      );

      await ubiService.editUbi(UbiModel(
        name: name,
        horari: horari,
        tipo: tipo,
        address: address,
        ubication: ubication,
        comentari: comentari,
      ), id);

      fetchUbis(); // Refresca la lista de ubicaciones
      clearForm();
      Get.snackbar("Èxit", "Ubicació editada correctament");
    } catch (e) {
      Get.snackbar("Error", "No s'ha pogut editar la ubicació");
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
      Get.snackbar("Èxit", "Ubicació eliminada correctament");
    } catch (e) {
      Get.snackbar("Error", "No s'ha pogut eliminar la ubicació");
    } finally {
      isLoading.value = false;
    }
  }

  // Limpiar los campos del formulario
  void clearForm() {
    nameController.clear();
    latitudeController.clear();
    longitudeController.clear();
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
