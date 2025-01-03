import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';

class UbiListController extends GetxController {
  var isLoading = true.obs;
  var ubis = <UbiModel>[].obs; // Lista reactiva de ubicaciones
  final UbiService _ubiService = UbiService(); // Instancia del servicio
  var selectedUbications = RxList<UbiModel>([]); // Lista de ubicaciones seleccionadas
  ScrollController scrollController = ScrollController(); // Controlador del scroll

  @override
  void onInit() {
    super.onInit();

    // Añadir un listener para el scroll
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener); // Limpiar el listener
    scrollController.dispose(); // Liberar el controlador
    super.onClose();
  }

  // Función para obtener ubicaciones cercanas
  Future<void> getNearbyUbis(double lat, double lon, double distance) async {
    try {
      // Validación de parámetros
      if (lat == null || lon == null || distance == null) {
        Get.snackbar('Error', 'Por favor, introduce valores válidos para latitud, longitud y distancia.');
        return;
      }

      isLoading(true); // Activamos el indicador de carga

      // Limpiamos la lista de ubicaciones anteriores
      ubis.clear();
      selectedUbications.clear(); // Limpiamos las ubicaciones seleccionadas

      // Llamar al servicio para obtener ubicaciones cercanas
      var fetchedUbis = await _ubiService.getNearbyUbis(lat, lon, 2);

      if (fetchedUbis != null && fetchedUbis.isNotEmpty) {
        ubis.assignAll(fetchedUbis); // Asignamos las ubicaciones obtenidas
        for (var ubi in fetchedUbis) {
          addSelectedUbi(ubi); // Añadir la ubicación seleccionada
        }
      } else {
        Get.snackbar('Error', 'No se encontraron ubicaciones cercanas.');
      }
    } catch (e) {
      print("Error obteniendo ubicaciones cercanas: $e");
      Get.snackbar('Error', 'Error al obtener ubicaciones cercanas.');
    } finally {
      isLoading(false); // Desactivamos el indicador de carga
    }
  }

  // Función para cargar más ubicaciones (Scroll infinito)
  Future<void> loadMoreUbis(double lat, double lon, double distance) async {
    if (isLoading.value) return; // Evita cargar más si ya estamos cargando

    try {
      isLoading(true); // Indicamos que estamos cargando más ubicaciones

      // Llamamos al servicio para obtener más ubicaciones
      var fetchedUbis = await _ubiService.getNearbyUbis(lat, lon, distance);

      if (fetchedUbis != null && fetchedUbis.isNotEmpty) {
        ubis.addAll(fetchedUbis); // Agregamos las nuevas ubicaciones a la lista existente
        for (var ubi in fetchedUbis) {
          addSelectedUbi(ubi); // Añadir las nuevas ubicaciones a las seleccionadas
        }
      }
    } catch (e) {
      print("Error cargando más ubicaciones: $e");
      Get.snackbar('Error', 'Error al cargar más ubicaciones.');
    } finally {
      isLoading(false); // Desactivamos el indicador de carga
    }
  }

  // Función para añadir una ubicación a las seleccionadas
  void addSelectedUbi(UbiModel ubi) {
    if (!selectedUbications.contains(ubi)) {
      selectedUbications.add(ubi); // Añadir ubicación a la lista de seleccionadas
    }
  }

  // Listener del scroll
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      // El usuario ha llegado al final de la lista, carga más ubicaciones
      loadMoreUbis(40.7128, -74.0060, 10.0);  // Aquí debes pasar la latitud, longitud y distancia
    }
  }
}

  // Método para eliminar una ubicación utilizando el id
  /*Future<void> deleteUbi(String ubiId) async {
    try {
      isLoading(true); // Establecemos el estado de carga a true
      var statusCode = await _ubiService.deleteUbiById(ubiId);
      if (statusCode == 200) {
        Get.snackbar('Éxito', 'Ubicación eliminada correctamente');
        getNearbyUbis(); // Actualiza la lista después de eliminar
      } else {
        Get.snackbar('Error', 'No se pudo eliminar la ubicación');
      }
    } catch (e) {
      print("Error deleting ubi: $e");
      Get.snackbar('Error', 'Hubo un error al eliminar la ubicación');
    } finally {
      isLoading(false);
    }
  }*/

