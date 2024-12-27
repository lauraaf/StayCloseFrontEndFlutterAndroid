import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart'; // Asegúrate de importar el servicio

class UbiListController extends GetxController {
  var ubis = <UbiModel>[].obs; // Lista reactiva de ubicaciones
  var isLoading = false.obs;

  final UbiService _ubiService = UbiService(); // Instancia del servicio

  // Función para obtener ubicaciones cercanas
  Future<void> getNearbyUbis(double lat, double lon, double distance) async {
    try {
      isLoading(true); // Activamos el indicador de carga
      List<UbiModel> fetchedUbis = await _ubiService.getNearbyUbis(lat, lon, distance);
      ubis.assignAll(fetchedUbis); // Asignamos las ubicaciones obtenidas
    } catch (e) {
      print("Error obteniendo ubicaciones cercanas: $e");
    } finally {
      isLoading(false); // Desactivamos el indicador de carga
    }
  }
}
