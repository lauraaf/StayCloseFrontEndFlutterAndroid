import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/ubi.dart';
import 'package:flutter_application_1/services/ubiServices.dart';
import 'package:geocoding/geocoding.dart'; // Paquete para geocodificación
import 'package:http/http.dart' as http; // Para hacer la solicitud HTTP
import 'dart:convert';
import 'package:flutter_application_1/services/userServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbiController extends GetxController {
  final ubiService = UbiService();

  var ubis = <UbiModel>[].obs;
  var ubisByType = <UbiModel>[].obs;
  var isLoading = false.obs;
  var isLoadingByType = false.obs;

  var nearbyUbisNames =<String>[].obs; // Lista solo de los nombres de las ubicaciones cercanas
  
  var errorMessage = ''.obs;
  var ubiType = ''.obs;
  var selectedType = 'Todos' .obs;
  

  final RxString _address = ''.obs;
  final UserService userService = Get.put(UserService());
  String get address => _address.value;

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
    loadUserAddress();
  }

  Future<Map<String, double>> loadUserAddress() async {
    try {
      // Obtenir l'ID de l'usuari des de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        // Crida al servei per obtenir l'adreça
        var user = await userService.getUser(userId);
        if (user != null) {
          _address.value = user.home ?? 'Adreça no disponible';
          // Un cop tinguem l'adreça, obtenim les coordenades
          return await getCoordinatesFromAddress(_address.value);
          
        } else {
          print('No s\'han pogut carregar les dades del usuari.');
          throw Exception('No s\'han pogut carregar les dades del usuari.');
          
        }
      } else {
        print('ID de l\'usuari no disponible a SharedPreferences.');
        throw Exception('ID de l\'usuari no disponible a SharedPreferences.');
      }
    } catch (e) {
      print('Error carregant l\'adreça del usuari: $e');
      throw Exception('Error carregant l\'adreça del usuari: $e');
    }
  }

// Funció per obtenir coordenades de l'adreça
  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    try {
      // Fem la crida HTTP a l'API de Nominatim per obtenir les coordenades
      print("Obteniendo coordenadas para la dirección: $address");
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
      final response = await http.get(url);
      print("Respuesta de la API: ${response.body}");

      // Comprovem que la resposta és correcte
      if (response.statusCode == 200) {
        print("code 200-------------------");

        final List<dynamic> data = json.decode(response.body);
        print("data: $data");

        // Si hi ha dades disponibles
        if (data.isNotEmpty) {
          // Processem les coordenades utilitzant tokens
          final tokens = response.body.split(',');

          // Buscar les claus 'lat' i 'lon' dins dels tokens
          String? latToken = tokens
              .firstWhere((token) => token.contains('"lat"'), orElse: () => '');
          String? lonToken = tokens
              .firstWhere((token) => token.contains('"lon"'), orElse: () => '');

          // Extraiem els valors numèrics després de "lat" i "lon"
          if (latToken.isNotEmpty && lonToken.isNotEmpty) {
            final double lat =
                double.parse(latToken.split(':')[1].replaceAll('"', '').trim());
            final double lon =
                double.parse(lonToken.split(':')[1].replaceAll('"', '').trim());

            print('Latitud: $lat');
            print('Longitud: $lon');

            // Retornem un mapa amb les coordenades
            return {'latitude': lat, 'longitude': lon};
          } else {
            throw Exception('No se encontraron valores de latitud o longitud.');
          }
        } else {
          throw Exception('Adreça no trobada.');
        }
      } else {
        throw Exception('Error en la crida a l\'API.');
      }
    } catch (e) {
      print('Error al geocodificar l\'adreça: $e');
      rethrow; // Tornem a llençar l'error per gestionar-lo a fora si cal
    }
  }

  // Obtener todas las ubicaciones
  Future<void> fetchUbis() async {
    isLoading.value = true;
    isLoadingByType.value = false;
    selectedType='Todos' .obs;
    try {
      final fetchedUbis = await ubiService.getUbis();
      ubis.value = fetchedUbis;
      // print("el getUbis es--------------: $ubis.value");
    } catch (e) {
      errorMessage.value = 'Error al cargar las ubicaciones.';
    } finally {
      isLoading.value = false;
    }
  }

   // Función para obtener las ubis filtradas por tipo
  void fetchUbisByType(String type) async {
    isLoadingByType.value = true;
    isLoading.value = false;

    // Traduce el tipo de post al código correcto antes de enviar
    String translatedUbiType = getCategoryCode(type);
    print("la traduccion del tipo es: $translatedUbiType");
    selectedType = translatedUbiType .obs;
    try {
      final fetchedUbisType = await ubiService.getUbisByType(translatedUbiType);
      print("el getUbis es: $ubis");
      ubisByType.value=fetchedUbisType;

    } finally {
      isLoadingByType.value = false;
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

  // Get the category code
  final categoryCode = categoryCodes[tipoController.text.trim()];
  print("esta es la categoria al crear: $categoryCode");
        // Hacer la solicitud de geocodificación para obtener las coordenadas
        final url = Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          print("data: $data");
          if (data.isNotEmpty) {
            final double lat = double.parse(data[0]['lat']);
            final double lon = double.parse(data[0]['lon']);

            // Crear el objeto Ubication
            final ubication = Ubication(
              type:
                  'Point', // El tipo de la ubicación, que normalmente será "Point" para coordenadas
              coordinates: [lon, lat], // La longitud y latitud
            );

            print("longitud: $lon, latitud: $lat");

            // Crear la ubicación (UbiModel)
            final newUbi = UbiModel(
              name: nameController.text.trim(),
              tipo: categoryCode!,
              horari: horariController.text.trim(),
              ubication: ubication, // Usamos la instancia de Ubication aquí
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

  // Mapeo entre categorías y sus códigos
  final Map<String, String> categoryCodes = {
    'Punto lila': 'P',
    'Hospital': 'H',
    'Centro': 'C',
    'Otros': 'O',
  };
  // Función para traducir la categoría seleccionada al código
  String getCategoryCode(String category) {
    return categoryCodes[category] ?? 'O'; // Por defecto "O" (Otro)
  }

}
